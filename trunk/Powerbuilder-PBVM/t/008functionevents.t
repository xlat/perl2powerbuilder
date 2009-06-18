use Test::More tests => 3 + 7;

BEGIN { use_ok('Powerbuilder::PBVM') };

my $session = new Powerbuilder::PBVM;
cmp_ok( ref($session) ,'eq', 'Powerbuilder::PBVM',    'constructor');

my $r = $session->CreateSession("scriptingpb", "t/scriptingpb.pbl", 1);
cmp_ok( $r ,'eq', 0, 'open session');



# Il faut créer un objet avec une fonction et un evennement
my $group = $session->FindGroup("nv_proto", pbgroup_userobject) or die "Bad group id !";
my $cls = $session->FindClass($group, "nv_proto") or die "Bad class id !";
my $pbobject = $session->NewObject( $cls );
SKIP:{
	skip "Functions and events not implemented.", 7 
		unless $pbobject;	
	my $mid = $session->GetMethodID($cls,"of_test", PBRT_FUNCTION, "III");
	cmp_ok( $mid, 'ne', kUndefinedMethodID, 'get method id');
	my $cinfo = new Powerbuilder::CallInfo;
	$session->InitCallInfo( $cls, $mid, $cinfo->get() );
	my $arg = new Powerbuilder::Arguments( $cinfo->Args() );
	my $argval = new Powerbuilder::Value( $arg->GetAt(0) );
	$argval->SetInt(48);
	$argval = new Powerbuilder::Value( $arg->GetAt(0) );
	$argval->SetInt(10);
	$r = $session->InvokeObjectFunction( $pbobject, $mid, $cinfo->get() );
	$session->FreeCallInfo( $cinfo->get() );
	cmp_ok( $r, 'eq', PBX_OK, 'invoke object function');
	
	my $eid = $session->GetMethodIDByEventID( $cls, "pbm_copy");
	cmp_ok( $eid, 'ne', kUndefinedMethodID, 'get event id');
	
	$mid = $session->GetMethodID( $cls, "ue_calc", PBRT_EVENT, "SIS");
	$cinfo = new Powerbuilder::CallInfo;
	$session->InitCallInfo( $cls, $mid, $cinfo->get() );
	$arg = new Powerbuilder::Arguments( $cinfo->Args() );	
	$argval = new Powerbuilder::Value( $arg->GetAt(0) );
	$argval->SetInt(10);
	$argval = new Powerbuilder::Value( $arg->GetAt(1) );
	$argval->SetString("test");
	$r = $session->TriggerEvent( $pbobject, $mid, $cinfo->get() );
	$session->FreeCallInfo( $cinfo->get() );
	cmp_ok( $r, 'eq', PBX_OK, 'invoke event');

	my $sgrp = $session->GetSystemGroup() or croak("GetSystemGroup failed");
	my $scls = $session->FindClass($sgrp, "SystemFunctions") or croak("FindClass(systemfunction) failed");
	my $smid = $session->GetMethodID($scls, "double", PBRT_FUNCTION, "DA") or croak("get mid of system function failed");
	$cinfo = new Powerbuilder::CallInfo;
	$session->InitCallInfo( $scls, $smid, $cinfo->get() );
	$arg = new Powerbuilder::Arguments( $cinfo->Args() );
	$argval = new Powerbuilder::Value( $arg->GetAt(0) );
	$argval->SetString("48");
	$r = $session->InvokeClassFunction( $scls, $smid, $cinfo->get() );
	cmp_ok( $r, 'eq', PBX_OK, 'invoke class function');
	my $returnValue = new Powerbuilder::Value( $cinfo->returnValue() );
	cmp_ok( $returnValue->GetDouble() , '==', 48, 'invoke class function (returnvalue)');
	$session->FreeCallInfo( $cinfo->get() );
	
	$mid = $session->FindMatchingFunction( $cls, "of_test", PBRT_FUNCTION, "long, int");
	cmp_ok( $mid, 'ne', 0, 'find matching function');
}