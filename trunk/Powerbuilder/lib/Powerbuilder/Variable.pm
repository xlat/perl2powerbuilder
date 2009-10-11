#!/usr/bin/perl
package Powerbuilder::Variable;
use Powerbuilder::PBVM;
use Powerbuilder::ClassDefinition;
use overload '""' => \&operator_toString, 
			fallback => 1;
use Carp;

#TODO: implement a sync() method to synchronize data from PB to perl
#	or from perl to PB
#	we could use an autosync property in "::Variable" or directly in "Powerbuilder" if needed...
our %typename = (
		"".Powerbuilder::PBVM::constant("pbvalue_int") => 'Int', 
		"".Powerbuilder::PBVM::constant("pbvalue_uint") => 'Uint', 
		"".Powerbuilder::PBVM::constant("pbvalue_byte") => 'Byte', 
		"".Powerbuilder::PBVM::constant("pbvalue_long") => 'Long', 
		"".Powerbuilder::PBVM::constant("pbvalue_longlong") => 'Longlong', 
		"".Powerbuilder::PBVM::constant("pbvalue_ulong") => 'Ulong', 
		"".Powerbuilder::PBVM::constant("pbvalue_real") => 'Real', 
		"".Powerbuilder::PBVM::constant("pbvalue_double") => 'Double', 
		"".Powerbuilder::PBVM::constant("pbvalue_dec") => 'Dec', 
		"".Powerbuilder::PBVM::constant("pbvalue_string") => 'String', 
		"".Powerbuilder::PBVM::constant("pbvalue_boolean") => 'Bool', 
		"".Powerbuilder::PBVM::constant("pbvalue_any") => 'PBAny',
		"".Powerbuilder::PBVM::constant("pbvalue_blob") => 'Blob',
		"".Powerbuilder::PBVM::constant("pbvalue_date") => 'Date',
		"".Powerbuilder::PBVM::constant("pbvalue_time") => 'Time',
		"".Powerbuilder::PBVM::constant("pbvalue_datetime") => 'DateTime',
		"".Powerbuilder::PBVM::constant("pbvalue_char") => 'Char',
		19 => 'Long',		#HACK for objhandle
	);

sub DEBUG{
	warn @_;
}

sub AUTOLOAD{
	my $sub = $AUTOLOAD;
	(my $field_or_method = $sub) =~ s/.*:://;
	my $self = shift;
	#~ DEBUG "autoload: <request>$AUTOLOAD</request><sub>$field_or_method</<sub>\n";
	croak("No class method for `$sub` !!!\n") unless defined($self); # && ref($self) eq __PACKAGE__;

	croak("Only Object can have AUTOLOAD ( $sub )!!!\n") unless $self->isobject;
	#first, look if a Method/Event exist with that's name
	if( 0 ){ #TODO: write it :)
		#this is a method, try to invoke it
		croak("Method / Event invokation Not implement yet!\n");
	}
	elsif(my $fid = $self->GetFieldID($field_or_method)){#this is supposed to be a field;
		#~ DEBUG "> fieldid = $fid\t";
		if(scalar(@_)){#setter
			#~ DEBUG "Setter mode\n";
			return $self->SetField( $field_or_method, @_ );
		}
		else{#getter
			#~ DEBUG "Getter mode\n";
			return $self->GetField( $field_or_method );
		}
	}else{
		croak("Field / Method $sub not found for pbobject `".$self->VM->GetClassName($self->classid)."` !\n");
	}
}

sub isnumeric{
	my $self = shift;
	return $self->VM->doesScalarContainNumber( $_[0] );
}

sub new{
	my $class = shift;
	my $self = bless { 
		value=> undef, 		#used in perl context
		pbvalue => undef,  	#used in PBNI API context
		isnull => 1,
		isobject => 0,
		isenum => 0,
		isstruct => 0,
		isarray => 0,			#a one or more dim array
		issimplearray => 0,		#an only one dim array
		datatypeof => -1,		#powerbuilder data type
		scope => 'anonymous',	#anonymous|argument|local|instance|shared|global|field
		hasacquired => 0,		#should we release it on DESTROY
		isreferenced => 0,		#should we dec reference on DESTROY
		enumName => undef,
		classname => undef,
		def => undef,
		classid => undef,
		groupid => undef,
	}, $class;
	$self->{session} = $Powerbuilder::SESSION;	#Always the last created instance of Powerbuilder package !
	$self->{VM} = $self->{session}->{VM};	#create alias :)
	
	unless( $self->can('VM') ){
		#May need to move pbvalue : use auto_load on `undef` for performance issue...
		#Load only once (all instance will share the same declaration)
		#initialize automethods.
		foreach my $sub( qw/ session VM isnull isobject isenum isstruct 
			isarray issimplearray datatypeof scope hasacquired isreferenced 
			classname classid groupid def enumName / ){
			my $clsub = $class."::".$sub;
			*$clsub = sub{ 
				return $_[0]->{$sub} unless scalar(@_)>1;
				return $_[0]->{$sub} = $_[1];
			};
		}
	}

	$self->set( @_ ) if @_;

	return $self;
}

sub create{	#hack for new => sugar creator for object.
	my ($perlclass, $pbclassname) = @_;
	return new( $perlclass, 'class' => $pbclassname);
}


sub value{
	my $self = shift;
	if(@_){
		#~ if($self->isarray){
			#~ return $self->{value} = @_;
		#~ }
		#~ else{
			return $self->{value} = shift;
		#~ }
	}
	return undef if $self->isnull;
	
	return @{$self->{value}} if $self->isarray && wantarray;
	return $self->{value};
}

sub pbvalue{
	my $self = shift;
	#TODO: test if undef, then change isnull to 1 !!!
	#TODO: SETTER: need to resync with powerbuilder: 
	#	in some case, it may need to call UpdateField() for visual properties...
	return $self->{pbvalue} = shift if @_;
	
	return undef if $self->isnull;
	
	#TODO: GETTER: need to resync with perl !!!
	#TODO: undef or not, need to resync with perl !!!
	if(!defined $self->{pbvalue}){
		return undef if $self->datatypeof == -1;	#not initialised
		#need to instantiate the pb value...
		#~ if($self->datatypeof == pbvalue_object){
		if($self->isobject){
			croak("Can't auto instantiate an pbobject!\n");
		}
		elsif($self->datatypeof == pbvalue_ulong or 
			$self->datatypeof == pbvalue_long or 
			$self->datatypeof == pbvalue_uint or 
			$self->datatypeof == pbvalue_int or
			$self->datatypeof == pbvalue_double or
			$self->datatypeof == pbvalue_real or
			$self->datatypeof == pbvalue_boolean or
			$self->datatypeof == pbvalue_byte or
			$self->datatypeof == pbvalue_char ){
			$self->{pbvalue} = $self->value;
		}
		elsif($self->datatypeof == pbvalue_string){
			$self->{pbvalue} = $self->VM->NewString( $self->value );
		}
		elsif($self->datatypeof == pbvalue_dec){
			$self->{pbvalue} = $self->VM->NewDecimal();
			#This is a very simple tostring() ----------.
			# may need to be improved !                 v
			$self->VM->SetDecimal( $self->{pbvalue}, "".$self->value );
		}
		elsif($self->datatypeof == pbvalue_blob){
			$self->{pbvalue} = $self->VM->getptr( $self->VM->NewBlob( $value, length($value) ) );
		}
		else{
			croak("** in pbvalue auto-instantiate Not implemented yet for datatypeof=".$self->datatypeof."!\n");
		}
	}
	return $self->{pbvalue};	
}

sub syncperl{
	my $self = shift;
	#reload in perl form the variable from Powerbuilder context
	#~ croak("syncperl Not implemented Yet !\n");
	$self->value( undef ) if $self->isnull;
	$self->value( undef ) if !defined $self->{pbvalue};	#Should die("") in this case ?
	$self->value( undef ) if $self->datatypeof == -1;		#not initialised
	#need to instantiate the pb value...
	if($self->isobject){
		#~ croak("sync perl pbobject Not implemented yet!\n");
		$self->value( $self );	#this is simmply a reference to ourself!
	}
	elsif($self->issimplearray){
		my $isnull=0;
		my @values;
		my $count=$self->VM->GetArrayLength($self->pbvalue);
		#~ warn ">DEBUG(syncperl::array) length=$count for ".$self->pbvalue."\n";
		for my $index(1..$count){
			my $type = $self->VM->GetArrayItemType($self->pbvalue,[$index]);
			#TODO: look if $type is an Object...
			#~ warn ">DEBUG(syncperl::array)type=$type\n";
			if($type > pbvalue_byte){
				#could be an enumerated datatype, or an object.
				#~ my $grp = $self->VM->GetSystemGroup;
				#~ warn ">DEBUG( ?($type) = " . (my $clsid = $self->VM->FindClassByClassID($grp,$type)) . "\n";
				#~ warn ">DEBUG( classname = " . $self->VM->GetClassName($clsid) . "\n";
				$type='Object';
			}
			my $value=undef;
			eval "\$value = \$self->VM->Get${type}ArrayItem(\$self->pbvalue,[\$index],\$isnull);";
			#~ warn ">DEBUG(syncperl::array) [$index]=(type=>$type,value=>$value,isnull=>$isnull)\n";
			if($isnull){
				push @values, undef;
			}
			else{
				my $nv = new Powerbuilder::Variable(type=>$type,value=>$value);
				push @values, $nv;
			}
		}
		$self->value( [ @values ] );
		#~ use Data::Dumper;
		#~ print ">>DBG>> " . Dumper( $self->value ) . " <<\n";
	}
	elsif($self->datatypeof == pbvalue_ulong or 
		$self->datatypeof == pbvalue_long or 
		$self->datatypeof == pbvalue_uint or 
		$self->datatypeof == pbvalue_int or
		$self->datatypeof == pbvalue_double or
		$self->datatypeof == pbvalue_real or
		$self->datatypeof == pbvalue_boolean or
		$self->datatypeof == pbvalue_byte or
		$self->datatypeof == pbvalue_char or
		$self->datatypeof == 19){ #Hack for objhandle !
		$self->value( $self->pbvalue() );
	}
	elsif($self->datatypeof == pbvalue_string){
		my $tmp = $self->VM->GetString( $self->pbvalue() );
		$self->value( "".$tmp );
		$self->VM->ReleaseString( $tmp ) if $self->VM->can('ReleaseString'); #from PB 11(.5 ?)
	}
	elsif($self->datatypeof == pbvalue_dec){
		#~ croak("sync perl pbdecimal Not implemented yet!\n");
		my $tmpstr = $self->VM->GetDecimalString( $self->{pbvalue} );
		$self->value( "".$tmpstr );
		$self->VM->ReleaseDecimalString( $tmpstr );
	}
	elsif($self->datatypeof == pbvalue_blob){
		$self->value( $self->VM->unref( $self->VM->GetBlob( $self->pbvalue ) ) );
	}
	elsif($self->isenum){
		croak("** IsEnum !!!!\n");
	}
	else{
		croak("** in syncperl auto-instantiate Not implemented yet for datatypeof=".$self->datatypeof."!\n");
	}
}

sub _inlineset{	
	my $self = shift;
	$self->isnull( shift );
	$self->isobject( shift );
	$self->isenum( shift );
	$self->isstruct( shift );
	$self->isarray( shift );
	$self->issimplearray( shift );
	$self->datatypeof( shift );
	#an undef value will cause to dynamically instantiate 
	#the value if possible (any seam to be difficult to 
	#create from PBNI : hack could be to create from a 
	#systemfunction which return an any...).
	$self->pbvalue( shift );	
	$self->value( shift );
}

sub set{
	my $self = shift;
	#1a)	un seul param => not an array
	#1b)	plusieur params=> an simplearray [more complex array are not handled]
	#2a)		ref( $parm ) eq "Powerbuilder::Variable" => this is easy
	#2b)		ref( $parm ) eq "Powerbuilder::Value" => come from a PBNI IPB_Value*
	#2c)		ref($param ) eq HASH && exists($param{type}) && exists($param{value}) => a native handle.
	#3c)		otherwhise we interprete the perldatatype
	#3c.1)		array => new Powerbuilder::Variable( @param )
	#3c.2)		hash => croak("unhandled HASH !\n")
	#3c.3)		scalar : isnumber && isdecimal => dec or real or double ?
				# how to make difference between a real Perl.String and a Perl.Number
				# => maybe using a Devel:: package
	#3c.4)		scalar : string

	#TODO: find a way to handle pbarray !
	#	may we could use ( 'array' => pbarray ) :)
	if(scalar(@_) == 2 && defined($_[0]) && $_[0] eq 'class'){
		#create an object of classname $_[1]
		my ($arg1, $classname) = @_;
		my $groupid;
		foreach my $group ( pbgroup_application , pbgroup_datawindow , pbgroup_function , 
			pbgroup_menu , pbgroup_proxy , pbgroup_structure , pbgroup_userobject , 
			pbgroup_window , pbgroup_unknown ){
			$groupid = $self->VM->FindGroup( $classname,  $group) and last;
		}
		#~ croak "no group for `$classname`" unless $groupid;
		$groupid = $self->VM->GetSystemGroup unless $groupid;
		
		my $classid = $self->VM->FindClass( $groupid, $classname ) or croak "no class for `$classname`";
		my $pbobj = $self->VM->NewObject( $classid ) or croak "could not create object for `$classname`";
		$self->classname( $classname );
		$self->classid( $classid );
		$self->groupid( $groupid );
		if(ref($self) =~ /^Powerbuilder::ClassDefinition$/){
			$self->def( $self );
		}
		else{
			$self->def( $self->session->GetClassDefinition( $classid ) );
		}
		$self->_inlineset( 0, 1, 0, 0, 0, 0, $classid, $pbobj, $self );
		return;
	}

	if(scalar(@_) == 4 && defined($_[0]) && $_[0] eq 'type' 
		&& defined($_[2]) && $_[2] eq 'value'){
		#This is of the form: ( type => pbvalue_object|'object', value=>323540159 )
		my ($type, $value) = ($_[1], $_[3]);
		my ($isobject, $isarray, $issimplearray) = (0,0,0);
		if( "$type" =~ /^[Oo]bject$/ ){
			$isobject = 1;
			$type = $self->VM->GetClass( $value );	#retrieve classId !
			$self->classid( $type );
			#~ warn "DEBUG( settings def from type=$type for $value)\n";
			if(ref($self) =~ /^Powerbuilder::ClassDefinition$/){
				$self->def( $self );
			}
			else{
				$self->def( $self->session->GetClassDefinition( $type ) );
			}
			$self->VM->AddGlobalRef($value);
		}
		elsif("$type" =~ /^[Aa]rray$/){
			$isarray = 1;
			$issimplearray = 1;	#no multi dimenstional array implementation yet !
			$type = pbvalue_any;
		}
		#TODO: may be buggy with perl's "sub value()" because it should be syncrhonised here !
		$self->_inlineset( !defined($value), $isobject, 0, 0, $isarray, $issimplearray, $type, $value, undef);
		#mean we take value from Powerbuilder session and store it in perl format
		$self->syncperl;
		return;
	}

	if(scalar(@_) > 1){
		#this is an array
		my @array = [];
		foreach my $param ( @_ ){
			push( @array, new Powerbuilder::Variable( $param ) );
		}
		$self->_inlineset( 0, 0, 0, 0, 1, 1, pbvalue_any, undef, @array);
		return;
	}
	#this is a scalar
	my $var = shift;
	if(ref($var) eq 'Powerbuilder::Variable'){
		#~ croak("Powerbuilder::Variable not implemented yet !\n");
		$self->set( type => $var->datatypeof, value => $var->pbvalue );
		return;
	}
	elsif(ref($var) eq 'Powerbuilder::Value'){
		croak("Powerbuilder::Value not implemented yet !\n");
		return;
	}	
	#Perl datatype...
	#Could be bugged with STRING/BLOB containning number
	#TODO: we may implement a real isNumber() method based on perl_internal::FLAG !
	if($self->isnumeric($var)){
		if($var =~/[.,]/){
			#decimal, double, real are all mapped as decimal (for better precision in moneratry works)
			#TODO: test if $var need to be mapped as double...
			$self->_inlineset( 0, 0, 0, 0, 0, 0, pbvalue_dec, undef, $var );
			return;
		}
		elsif($var >= 0){
			$self->_inlineset( 0, 0, 0, 0, 0, 0, pbvalue_ulong, undef, $var );
			return;
		}
		else{
			$self->_inlineset( 0, 0, 0, 0, 0, 0, pbvalue_long, undef, $var );
			return;
		}
	}
	else{#string variable
		$self->_inlineset( 0, 0, 0, 0, 0, 0, pbvalue_string, undef, $var );
		return;
	}
	
}

#do not need to code another getters :
#sub get{ ... }  : two getters are needed : one for perl_context, one for powerbuilder_context...
#sub get_perl => value
#sub get_pb => pbvalue 

sub FieldCount{
	my $self = shift;
	#THIS IS NOT RELIABLE ON SYSTEM CLASS LIKE ClassDefinition, etc... !
	#~ return $self->VM->GetNumOfFields( $self->classid );
	#~ warn "FieldCount...\n";
	return $self->def->GetVariableCount;
}

sub GetTypeName{
	my ($self, $type, $isobject, $isarray, $isenum, $isstruct) = @_;
	unless(defined($type)){
		use Data::Dumper;
		die "GetTypeName has not TYPE defined !\n" . Dumper( caller ) . "\n";
	}
	return 'Array' if $isarray;
	return 'Object' if $isobject or "$type" eq "16583"; #TODO: use a Powerbuilder::PBVM constant to define classdefintion type... for 16583?
	$type = pbvalue_int if $isenum;
	#remap type id to name of type
	return $typename{$type} if exists $typename{$type};
	#~ croak("Unknow type: $type !\n");
	return $type;
}

sub GetField{
	my ($self, $fieldname, $ftype) = @_;
	my $cid = $self->classid;
	my $fid = $self->VM->GetFieldID($cid, $fieldname );
	my $type;
	my ($isobject, $isarray, $isenum) = (0, $self->VM->IsFieldArray( $cid, $fid ), 0);
	#~ warn "GetField( $fieldname, `".(defined($ftype)?$ftype:'undef')."` )\n";
	if(defined($ftype)){
		#~ warn "\$ftype is known as $ftype, initializing \$type\n";
		$type = $ftype;
		$type = $typename{$type} if exists $typename{$type};	#remap for pbvalue_* in ftype
		$isobject = ( lc("$ftype") eq "object" ) ;
	}
	else{
		#~ warn "\$ftype is unknown, auto-initializing \$type...\n";
		$ftype ||= $self->VM->GetFieldType($cid, $fid);
		$type = $self->GetTypeName( $ftype,
									$isobject = $self->def->IsObject($fieldname), 
									$isarray,
									$isenum = $self->def->IsEnum($fieldname),
									$self->def->IsStruct($fieldname),
									);
	}
	#~ warn "\$type is initialized to $type.\n";
	my $isnull=0;
	my $value;
	#~ warn "PBNI says field type is ". $self->VM->GetFieldType($cid, $fid) ."\n";
	#~ warn "eval( '\$self->VM->Get${type}Field(\$self->pbvalue, $fid, \$isnull)' )\n";
	if($isobject){ #Hack for invalid object handle... involving PBNI to crash !
		my $tmphandle = $self->VM->GetLongField($self->pbvalue,$fid,$isnull);
		#~ warn "GetField($fieldname) => object ($value) => tmphandle = $tmphandle\n";
		return undef unless $tmphandle;
	}
	eval( "\$value = \$self->VM->Get${type}Field(\$self->pbvalue, $fid, \$isnull)" );
	my $field;
	#~ warn "<DEBUG>GetField($fieldname,$ftype) <cid>$cid</cid><fid>$fid</fid><type>$type</type><value>$value</value><isobject>$isobject</isobject><isenum>$isenum</isenum><isarray>$isarray</isarray></DEBUG>\n";
	
	if($isarray){
		#~ croak("Array not handled yet!\n");
		#~ warn "initializing object $fieldname as array\n";
		$field = new Powerbuilder::Variable(type=>'array', value=> $value);
		#TODO: handle arrays !!!
		#if SimpleArray :
			# loop on each item and buil a list of args for new Powerbuilder::Variable(...)
		#else
			# may we should create an array of array ?
			# string t[2][2] in powerbuilder => [ [0, 1], [0, 1] ] in perl...
			#or add PBLike getter :
			#	my $vararray->get( dim1_index, dim2_index, ... );
			#	my $vararray->set( dim1_index, dim2_index, ... );
			#	my $vararray->upperbound( dim_id );
			#	my $vararray->lowerbound( dim_id );
	}elsif($isobject){
		#~ warn "Object value=$value\n";
		#~ croak "void object !\n" if $value == 0;
		if("$ftype" eq '16583'){ 
			#TODO: use a constant for ClassDefinition's typeof internal value
			# or this could be determined at runtime at load time (in BEGIN{ } of that package...)
			$field = new Powerbuilder::ClassDefinition( type=>'object', value=>$value );
		}
		else{
			#~ warn "GetField ... -> creating Variable( object, $value )\n";
			$field = new Powerbuilder::Variable( type=>'object', value=>$value );
		}
		$field->scope('field'); #todo: rationalize scopes!!!
	}
	elsif($isenum){
		$field = new Powerbuilder::Variable( type => pbvalue_int, value => $value );
		$field->isenum( $isenum );
		$field->enumName( $self->def->GetVariable($fieldname)->typeinfo->name );
		#TODO: add something to remember EnumTypeName using $self->def->GetVariable($fieldname)->typeinfo->name
	}
	else{
		$field = new Powerbuilder::Variable( type => $ftype, value => $value );
	}
	$field->isnull( $self->VM->IsFieldNull($self->pbvalue, $fid) );
	return $field;
}

sub IsFieldNull{
	my $self = shift;
	my $fieldname = shift;
	my $cid = $self->classid;
	my $fid = $self->VM->GetFieldID($cid, $fieldname );
	return $self->VM->IsFieldNull($self->pbvalue, $fid);
}

sub SetField{
	my ($self, $fieldname, $value) = @_;
	my $cid = $self->classid;
	my $fid = $self->VM->GetFieldID($cid, $fieldname );
	
	if(!defined($value)){
		$self->VM->SetFieldNull( $self->pbvalue, $fid );
		return;
	}
	
	my $type = $self->GetTypeName( my $ftype=$self->VM->GetFieldType($cid,$fid),
									$self->def->IsObject($fieldname), 
									$self->VM->IsFieldArray( $cid, $fid ),
									$self->def->IsEnum($fieldname),
									$self->def->IsStruct($fieldname),
									);

	if(ref($value) eq 'Powerbuilder::Variable'){
		$value = $value->pbvalue;
	}
	else{
		#~ croak("#TODO: handle type missmatch here or let's perl XS stubs do this work...
		#~ ftype='$ftype'
		#~ type='$type'
		#~ ref(\$value)=".ref($value)."
		#~ ");
		#assertPBType( $value, $type );
	}
	eval( "\$self->VM->Set${type}Field(\$self->pbvalue, $fid, \$value)" );
}

sub GetFieldName{
	my ($self, $fid) = @_;
	return $self->VM->GetFieldName( $self->classid, $fid );
}
sub GetFieldID{
	my ($self, $fname) = @_;
	my $fid = $self->VM->GetFieldID( $self->classid, $fname );
	return undef if $fid == 0xffff;
	return $fid;
}

sub ClassName{
	my $self = shift;
	return $self->VM->GetClassName( $self->classid );
}

#Enumeration related
sub EnumItemName{
	my $self = shift;
	return $self->VM->GetEnumItemName( $self->enumName, $self->value );
}
#TODO: sub EnumerationItems{} => return all enumerations itemName available in this enumName.

#TODO: next step = method & SIG !

sub operator_toString{
	return $_[0]->value;
}

sub DESTROY{
	my $self = shift;
	#~ $self->VM->RemoveGlobalRef($self->pbvalue) if $self->isobject;
	#~ (in cleanup) Can't call method "RemoveGlobalRef" on an undefined value at ../Variable.pm line ^ during global destruction.
}
1;