#!/usr/bin/perl
#This will be a prof of concept of a futur packages 
# Powerbuilder::Object, Powerbuilder::Enum

BEGIN{
	use Cwd;
	$saved_dir = cwd();
};

use Powerbuilder;
use Powerbuilder::PBVM;
chdir '../t';
my $pb = new Powerbuilder( 'scriptingpb.pbt' );
$session = $pb->VM;

$|=1;

my %pbni_values = ( #May be quicker if defined in Powerbuilder::PBVM->GetField($pbobject,$name) => pbvalue (void*)
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
);

sub getStringFieldByName{
	my $pb = shift;
	my $object = shift;
	my $fieldname = shift;
	my $cls = $pb->GetClass( $object );
	my $fid = $pb->GetFieldID( $cls, $fieldname );
	my $isnull;
	my $field = $pb->GetStringField($object,$fid,$isnull);
	return ($field, $isnull ) if wantarray;
	return $field;
}

sub is_enumerated{
	#Could we write a sort of XPath parser for that kind of cheat|shit ?
	# $obj->get("classdefinition.variablelist[.name eq $fieldname].typeinfo.category")
	# $obj->get("classdefinition.variablelist[]") => @variablelists	
	my $pb = shift;
	my $class = shift;
	my $fieldname = shift;
	my $is_enum = 0;
	my $classname = $session->GetClassName($class);
	my $returnValue = get_classdefinition($session, $classname);
	my $classdefinition = $returnValue->GetObject();
	my $variablelist = get_field( $session, $classdefinition, "variablelist" );
	foreach my $var (simple_array_iterator($session, $variablelist)){		
		my $name = get_field($session, $var, "name");
		my $varname =  $session->GetString( $name );
		if($varname eq $fieldname){
			my $typeinfo = get_field($session, $var, "typeinfo", "Object");
			my $category = get_field($session, $typeinfo, "category", "Uint");
			$is_enum= ( $session->GetEnumItemName("typecategory", $category) eq 'enumeratedtype' ); 
			last;
		}
	}
	$session->ReleaseValue( $returnValue->get() );
	return $is_enum;
}

sub get_field{
	#sould be called as:  my $value = get_field( $pb, $myitem, "propertyName" );
	my $pb = shift;
	my $object = shift;
	my $fieldname = shift;
	my $defaulttype = shift || undef;
	my $cls = $pb->GetClass( $object );
	my $fid = $pb->GetFieldID( $cls, $fieldname );
	#its depend on the field type !!!
	my $field;
	my $isnull;
	if($pb->IsFieldNull($object, $fid)){
		($field , $isnull)= (undef, 1);
	}elsif($pb->IsFieldArray( $cls, $fid )){
		$field = $pb->GetArrayField( $object, $fid, $isnull );
	}
	elsif($pb->IsFieldObject( $cls, $fid ) or 
		defined($defaulttype) and lc($defaulttype) eq 'object'){
		$field = $pb->GetObjectField( $object, $fid, $isnull );
	}
	else{
		my $ftype = $pb->GetFieldType( $cls, $fid );
		#hack to handle Enumerationdatatype...
		unless(exists $pbni_values{$ftype} or defined $defaulttype){
			#could be an enum => Uint
			#or an object => Object
			if(is_enumerated($pb, $cls, $fieldname)){ #Because Powerbuilder can lie on objects... (eg. VariableDefinition.TypeInfo field of type TypeDefinition)
				$field = $pb->GetUintField( $object, $fid, $isnull );
			}
			else{
				#~ print "DEBUG< type= $ftype > (" . $dword . " ) ";
				#~ print $pb->GetClass( $dword ) . ", ";
				#~ my $clid = $pb->FindClassByClassID( $pb->GetSystemGroup(), $ftype );
				#~ print "=> classId = $clid : " . $pb->GetClassName($clid) . "\n";
				#~ $field = $pb->GetObjectField( $object, $fid, $isnull ) if $clid;
				$field = $pb->GetObjectField( $object, $fid, $isnull );
			}
		}else{
			#~ print "get_field( ..., $cls, $fieldname => fid = $fid : type=$ftype ) =>";
			my $type;
			$type = exists $pbni_values{$ftype} ? $pbni_values{$ftype} : $defaulttype ;
			eval("\$field = \$pb->Get".$type.'Field($object,$fid,$isnull);');
			#~ print "$field ($isnull)\n";
		}
	}
	
	return ($field, $isnull ) if wantarray;
	return $field;
}

sub simple_array_iterator{
	#take session, array and return an array of arguments
	my ($session, $array) = @_;
	my @iterator = ();
	my $count = $session->GetArrayLength($array);
	#~ print "simple_array_iterator : count = $count\n";
	for my $i (1..$count){
		#~ print "simple_array_iterator : i = $i\t";
		my $item = $session->GetObjectArrayItem($array, [$i], $isnull);		
		if ($isnull){
			#~ print "item is null\n";
			push @iterator, undef;
		}
		else{
			#~ print "item = $item\n";
			push @iterator, $item;
		}
	}
	return @iterator;
}

sub get_arg_sig{
	my ($session, $argarray) = @_;
	my $proto = "";
	my %sig_prefix = ( 'byvalueargument' => '', 'byreferenceargument' => 'R', 
		'readonlyargument' => 'X', 'varlistargument' => 'V', );
	my %sig_part = ( 
		'array' => "[]", 'any' => "A", 'boolean' => "B", 'class' => "C", 'double' => "D",
		'byte' => "E", 'real' => "F", 'basictype' => "G", 'character' => "H", 'integer' => "I",
		'cursor' => "J", 'longlong' => "K", 'long' => "L", 'decimal' => "M", 'unsignedinteger' => "N",
		'uint' => "N", 'blob' => "O", 'dbproc' => "P", 'no type' => "Q", 'string' => "S",
		'time' => "T", 'unsignedlong' => "U", 'ulong' => "U", 'datetime' => "W", 'date' => "Y",
		'objhandle' => "Z", 	);
	foreach my $arg ( simple_array_iterator($session, $argarray) ){
		my $callconvalue = get_field( $session, $arg, "callingconvention" );
		my $callconv = $session->GetEnumItemName("argcallingconvention", $callconvalue);
		
		$proto .= $sig_prefix{$callconv};
		my $typeinfo = get_field( $session, $arg, "typeinfo" );
		if($typeinfo == 0){
			$proto .= "Q";
		}
		else{			
			my $datatypeof = get_field($session, $typeinfo, "datatypeof");
			my $datatypeofstr = $session->GetString( $datatypeof );
			if(exists $sig_part{$datatypeofstr}){
				$proto .= $sig_part{$datatypeofstr};
			}
			else{
				$proto .="C".$datatypeofstr.".";
			}
			my $cardinality = get_field($session, $arg, "cardinality");
			my $cardinalityvalue = get_field($session, $cardinality, "cardinality");
			my $cardinalityname = $session->GetEnumItemName("variablecardinalitytype", $cardinalityvalue);
			if($cardinalityname ne 'scalartype'){
				if($cardinalityname eq 'boundedarray'){
					warn "unhandled sig for boundered array !\n";
					$proto .="[]";
				}
				else{
					$proto .="[]";
				}
			}
			$session->ReleaseString( $datatypeofstr ) if $session->can('ReleaseString');
		}
	}
	return $proto;
}


sub get_classdefinition{
	my $session = shift;
	my $class = shift; #could be the Id or the Name;
	$class = $session->GetClassName( $class ) if $class =~ /^\d+$/;
	
	my $sgrp = $session->GetSystemGroup() or croak("GetSystemGroup failed");
	my $scls = $session->FindClass($sgrp, "SystemFunctions") or croak("FindClass(systemfunction) failed");
	#~ "FindClassDefinition", "Cclassdefinition.S"
	my $smid = $session->GetMethodID($scls, "FindClassDefinition", PBRT_FUNCTION, "Cclassdefinition.S") or croak("get mid of system function failed");
	my $cinfo = new Powerbuilder::CallInfo;
	$session->InitCallInfo( $scls, $smid, $cinfo->get() );
	$arg = new Powerbuilder::Arguments( $cinfo->Args() );
	my $argval = new Powerbuilder::Value( $arg->GetAt(0) );
	$argval->SetString($class);
	$session->InvokeClassFunction( $scls, $smid, $cinfo->get() );
	my $returnValue = new Powerbuilder::Value( $session->AcquireValue( $cinfo->returnValue() ));
	die "NoClassDefinition for `$class`!\n" if $returnValue->IsNull();
	$session->FreeCallInfo( $cinfo->get() );
	return $returnValue;
}
#1) Inspect a classdefinition for systemfunctions,
#in order to retrieve @prototypes in the given classdefinition.
my $returnValue = get_classdefinition($session,"systemfunctions");
my $classdefinition = $returnValue->GetObject();
my $classid = $session->GetClass( $classdefinition );
my $fid = $session->GetFieldID($classid, "scriptlist");
my $isnull=0;
my $scripts_array = $session->GetArrayField($classdefinition,$fid, $isnull);
my $i = 1;
foreach my $script (simple_array_iterator($session, $scripts_array)){
	my $pbstring = get_field($session, $script, "name");
	my $script_name = $session->GetString( $pbstring );
	if($script_name !~ /^(?:create|destroy)$/){
		my $argsig = get_arg_sig( $session, get_field($session, $script, "argumentlist") );
		print "$script_name ( $argsig )\n";
	}else{ warn "create or destroy may crash so I skip them !\n"; }
	$session->ReleaseString( $script_name ) if $session->can('ReleaseString');	#seams to be added from PB 11.5
}
$session->ReleaseValue( $returnValue->get() );
#2) Retrieve @prototypes available for a given function|event name.


END{
	chdir $saved_dir;
};