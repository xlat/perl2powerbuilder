#!/usr/bin/perl
package Powerbuilder::Variable;
use Powerbuilder::PBVM;
use Carp;

#TODO: implement a sync() method to synchronize data from PB to perl
#	or from perl to PB
#	we could use an autosync property in "::Variable" or directly in "Powerbuilder" if needed...

sub isnumeric{
	use Scalar::Util qw( looks_like_number  );
	return &looks_like_number;
}	#may I use a Devel::Peek to be sure...

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
		scope => 'anonymous',	#anonymous|argument|local|instance|shared|global
		hasacquired => 0,		#should we release it on DESTROY
		isreferenced => 0,		#should we dec reference on DESTROY
	}, $class;
	$self->{session} = $Powerbuilder::SESSION;	#Always the last created instance of Powerbuilder package !
	$self->{VM} = $self->{session}->{VM};	#create alias :)
	
	unless( $self->can('VM') ){
		#May need to move pbvalue : use auto_load on `undef` for performance issue...
		#Load only once (all instance will share the same declaration)
		#initialize automethods.
		foreach my $sub( qw/ SESSION VM value isnull isobject isenum isstruct 
			isarray issimplearray datatypeof scope hasacquired isreferenced / ){
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
	#reload in perl form the variable from Powerbilder context
	#~ croak("syncperl Not implemented Yet !\n");
	$self->value( undef ) if $self->isnull;
	$self->value( undef ) if !defined $self->{pbvalue};	#Should die("") in this case ?
	$self->value( undef ) if $self->datatypeof == -1;		#not initialised
	#need to instantiate the pb value...
	if($self->isobject){
		croak("sync perl pbobject Not implemented yet!\n");
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
		$self->value( $self->pbvalue() );
	}
	elsif($self->datatypeof == pbvalue_string){
		my $tmp = $self->VM->GetString( $self->pbvalue() );
		$self->value( "".$tmp );
		$self->VM->ReleaseString( $tmp ) if $self->VM->can('ReleaseString'); #from PB 11(.5 ?)
	}
	elsif($self->datatypeof == pbvalue_dec){
		croak("sync perl pbdecimal Not implemented yet!\n");
		#~ $self->{pbvalue} = $self->VM->NewDecimal();
		#~ #This is a very simple tostring() ----------.
		#~ # may need to be improved !                 v
		#~ $self->VM->GetDecimal( $self->{pbvalue}, "".$self->value );
	}
	elsif($self->datatypeof == pbvalue_blob){
		#~ $self->value( $self->VM->GetBlob( $self->pbvalue ) );
		$self->value( $self->pbvalue );
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

	if(scalar(@_) == 4 && defined($_[0]) && $_[0] eq 'type' 
		&& defined($_[2]) && $_[2] eq 'value'){
		#This is of the form: ( type => pbvalue_object|'object', value=>323540159 )
		my ($type, $value) = ($_[1], $_[3]);
		#TODO: may be tricky with perl's "sub value()" because it should be syncrhonised here !
		$self->_inlineset( !defined($value), 0, 0, 0, 0, 0, $type, $value, undef);
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
		$self->_inlineset( 0, 0, 0, 0, 1, 1, pbvalue_array, undef, @array);
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
	if(isnumeric($var)){
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


#~ sub DESTROY{
	#~ my $self = shift;
#~ }
1;