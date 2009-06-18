#!/usr/bin/perl
my $saved_dir;
BEGIN{
	use Cwd;
	$saved_dir = cwd();
};

use Powerbuilder::PBVM;

sub dump_fields{
	my $pb = shift;
	my $scls = shift;
	my $clsname = $pb->GetClassName($scls);
	print "Fields of $clsname class:\n";
	print " - have " . $pb->GetNumOfFields($scls) . " fields\n";
	foreach my $fid (1..$pb->GetNumOfFields($scls)){
		print "\t";
		print $pb->GetFieldName( $scls, $fid );
		print ", ";
		print $pb->GetFieldType( $scls, $fid );
		print "\n";
	}	
}

sub get_classdefinition{
	my $pb = shift;
	my $classname = shift;

	my $sgrp = $pb->GetSystemGroup() or croak("GetSystemGroup failed");
	my $scls = $pb->FindClass($sgrp, "SystemFunctions") or croak("FindClass(systemfunction) failed");
	my $smid = $pb->GetMethodID($scls, "findclassdefinition", PBRT_FUNCTION, "Cclassdefinition.S") or croak("get mid of system function failed");
	my $cinfo = new Powerbuilder::CallInfo;
	$pb->InitCallInfo( $scls, $smid, $cinfo->get() );
	my $arg = new Powerbuilder::Arguments( $cinfo->Args() );
	my $argval = new Powerbuilder::Value( $arg->GetAt(0) );
	$argval->SetString( $classname );
	$pb->InvokeClassFunction( $scls, $smid, $cinfo->get() );
	my $returnValue = new Powerbuilder::Value( $pb->AcquireValue($cinfo->returnValue() ) );
	$pb->FreeCallInfo( $cinfo->get() );
	return $returnValue;
}

$|=1;

my %pbni_values = (
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
		"".Powerbuilder::PBVM::constant("pbvalue_any") => 'Any',
		"".Powerbuilder::PBVM::constant("pbvalue_blob") => 'Blob',
		"".Powerbuilder::PBVM::constant("pbvalue_date") => 'Date',
		"".Powerbuilder::PBVM::constant("pbvalue_time") => 'Time',
		"".Powerbuilder::PBVM::constant("pbvalue_datetime") => 'DateTime',
		"".Powerbuilder::PBVM::constant("pbvalue_char") => 'Char',
);

sub get_field{
	#sould be called as:  my $value = get_field( $pb, $myitem, "propertyName" );
	my $pb = shift;
	my $object = shift;
	my $fieldname = shift;
	local $|=1;
	
	my $cls = $pb->GetClass( $object );
	my $fid = $pb->GetFieldID( $cls, $fieldname );
	
	#its depend on the field type !!!
	my $field;
	my $isnull;
	if($pb->IsFieldArray( $cls, $fid )){
		$field = $pb->GetArrayField( $object, $fid, $isnull );
	}
	elsif($pb->IsFieldObject( $cls, $fid )){
		$field = $pb->GetObjectField( $object, $fid, $isnull );
	}
	else{
		my $ftype = $pb->GetFieldType( $cls, $fid );
		eval("\$field = \$pb->Get".$pbni_values{$ftype}.'Field($object,$fid,$isnull);');
	}
	#if wantarray then return ($field, $isnull );
	return $field;
}

sub dump_scripts{
	my $pb = shift;
	my $scls = shift;
	local $|=1;
	$pb->PushLocalFrame;
	my $clsname = $pb->GetClassName($scls);
	my $classdef = get_classdefinition($pb, $clsname) or die "Can't retrieve classdefinition object";
	print "Scripts of $clsname class:\n";
	#Should get field ScriptList as an ObjectArray
	my $scriptlist = get_field( $pb, $classdef->GetObject, "scriptlist" );
	print " - " . $pb->GetArrayLength($scriptlist) . " scripts\n";
	my $isnull;
	foreach my $i (1..$pb->GetArrayLength($scriptlist)){
		print "\t$i)";
		#get arrayitem
		my $scriptdef = $pb->GetObjectArrayItem( $scriptlist, [$i], $isnull ) or die "can't get scriptdef\n";
		my $scriptname = get_field( $pb, $scriptdef, "name" ) or die "can't get scriptname!\n";
		print $pb->GetString( $scriptname );
		#get script.definition value
		print "\n";
	}
	
	$pb->ReleaseValue( $classdef->get );
	$pb->PopLocalFrame;
}


sub new_object{
	my $pb = shift;
	my $classname = shift;
	my $grouptype = shift;
	my ($pbclass, $pbgroup);
	$pbgroup = $pb->FindGroup( $classname, $grouptype );
	$pbclass = $pb->FindClass( $pbgroup, $classname);
	return $pb->NewObject( $pbclass );
}
my $projectfile = 'explore.pbt';
chdir 'C:\Developpement\Powerbuilder\explore-2.1.0\Sources';

my $pb = new Powerbuilder::PBVM;

$pb->CreateSession( $pb->project( $projectfile ) );
	#~ or die "Can't open session using $projectfile !\n";

#Write some test using powerbuilder native interface
my $sgrp = $pb->GetSystemGroup() or croak("GetSystemGroup failed");
my $scls = $pb->FindClass($sgrp, "SystemFunctions") or croak("FindClass(systemfunction) failed");

dump_fields( $pb, $scls );
dump_scripts( $pb, $scls );

#Idées:
#======
# * scanner les fonctions disponibles de la class system
#   ** via ClassDefinition si necessaire...
#  --> au final écrire un package Powerbuilder::Reflexion::( dump, functions|prototypes, properties )

my $app = new_object( $pb, "explore", pbgroup_application );
print "\n-----------------------\nApp:\n";
dump_scripts( $pb, $pb->GetClass( $app ) );



{# TRY TO OPEN APP...
	my $cls = $pb->GetClass( $app );
	my $mid = $pb->GetMethodID( $cls, "hackopen", PBRT_EVENT, "QS");
	my $cinfo = new Powerbuilder::CallInfo;
	$pb->InitCallInfo( $cls, $mid, $cinfo->get() );
	my $arg = new Powerbuilder::Arguments( $cinfo->Args() );	
	my $argval = new Powerbuilder::Value( $arg->GetAt(0) );
	$argval->SetString("");
	$pb->TriggerEvent( $app, $mid, $cinfo->get() );
	$pb->FreeCallInfo( $cinfo->get() );
}# END TRY TO OPEN APP

{# TRY TO OPEN APP...
	my $cls = $pb->GetClass( $app );
	my $mid = $pb->GetMethodID( $cls, "open", PBRT_EVENT, "QS");
	my $cinfo = new Powerbuilder::CallInfo;
	$pb->InitCallInfo( $cls, $mid, $cinfo->get() );
	my $arg = new Powerbuilder::Arguments( $cinfo->Args() );	
	my $argval = new Powerbuilder::Value( $arg->GetAt(0) );
	$argval->SetString("");
	$pb->TriggerEvent( $app, $mid, $cinfo->get() );
	$pb->FreeCallInfo( $cinfo->get() );
}# END TRY TO OPEN APP




$pb->ReleaseSession();

END{
	chdir $saved_dir;
};