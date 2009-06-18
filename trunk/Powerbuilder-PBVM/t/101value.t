use Test::More tests => 3+12;

BEGIN { use_ok('Powerbuilder::PBVM') };

my $session = new Powerbuilder::PBVM;
cmp_ok( ref($session) ,'eq', 'Powerbuilder::PBVM',    'constructor');

my $r = $session->CreateSession("scriptingpb", "t/scriptingpb.pbl", 1);
cmp_ok( $r ,'eq', 0, 'open session');


#prepare a CallInfo to retrieve an pointer to a Powerbuilder::Value
my $sgrp = $session->GetSystemGroup() or croak("GetSystemGroup failed");
my $scls = $session->FindClass($sgrp, "SystemFunctions") or croak("FindClass(systemfunction) failed");
my $smid = $session->GetMethodID($scls, "double", PBRT_FUNCTION, "DA") or croak("get mid of system function failed");
my $cinfo = new Powerbuilder::CallInfo;
$session->InitCallInfo( $scls, $smid, $cinfo->get() );
my $arg = new Powerbuilder::Arguments( $cinfo->Args() );
my $argvl = new Powerbuilder::Value( $arg->GetAt(0) );
my $argval = new Powerbuilder::Value( $session->AcquireValue( $argvl->get ) );
cmp_ok( $argval, 'ne', 0, 'AcquireValue' );
#~ cmp_ok( $argval->SetArray("48"), 'eq', PBX_OK, 'set array');
#~ cmp_ok( $argval->SetBlob("48"), 'eq', PBX_OK, 'set blob');
cmp_ok( $argval->SetBool(1), 'eq', PBX_OK, 'set bool');
cmp_ok( $argval->SetToNull(), 'eq', PBX_OK, 'set to null');
$session->ReleaseValue( $argval->get );

$argval = new Powerbuilder::Value( $session->AcquireValue( $argvl->get ) );
cmp_ok( $argval->SetByte(128), 'eq', PBX_OK, 'set byte');
$session->ReleaseValue( $argval->get );

$argval = new Powerbuilder::Value( $session->AcquireValue( $argvl->get ) );
cmp_ok( $argval->SetChar('1'), 'eq', PBX_OK, 'set char');
$session->ReleaseValue( $argval->get );

#~ $argval = new Powerbuilder::Value( $session->AcquireValue( $argvl->get ) );
#~ cmp_ok( $argval->SetDate("48"), 'eq', PBX_OK, 'set date');
#~ $session->ReleaseValue( $argval->get );

#~ $argval = new Powerbuilder::Value( $session->AcquireValue( $argvl->get ) );
#~ cmp_ok( $argval->SetTime("48"), 'eq', PBX_OK, 'set time');
#~ $session->ReleaseValue( $argval->get );

#~ $argval = new Powerbuilder::Value( $session->AcquireValue( $argvl->get ) );
#~ cmp_ok( $argval->SetDateTime("48"), 'eq', PBX_OK, 'set datetime');
#~ $session->ReleaseValue( $argval->get );

#~ $argval = new Powerbuilder::Value( $session->AcquireValue( $argvl->get ) );
#~ cmp_ok( $argval->SetDecimal("48.00"), 'eq', PBX_OK, 'set decimal');
#~ $session->ReleaseValue( $argval->get );

$argval = new Powerbuilder::Value( $session->AcquireValue( $argvl->get ) );
cmp_ok( $argval->SetDouble(48.11), 'eq', PBX_OK, 'set double');
$session->ReleaseValue( $argval->get );

$argval = new Powerbuilder::Value( $session->AcquireValue( $argvl->get ) );
cmp_ok( $argval->SetInt(48), 'eq', PBX_OK, 'set int');
$session->ReleaseValue( $argval->get );

$argval = new Powerbuilder::Value( $session->AcquireValue( $argvl->get ) );
cmp_ok( $argval->SetLong(480), 'eq', PBX_OK, 'set long');
$session->ReleaseValue( $argval->get );

#~ $argval = new Powerbuilder::Value( $session->AcquireValue( $argvl->get ) );
#~ cmp_ok( $argval->SetObject( $pbobject ), 'eq', PBX_OK, 'set object');
#~ $session->ReleaseValue( $argval->get );

#~ $argval = new Powerbuilder::Value( $session->AcquireValue( $argvl->get ) );
#~ cmp_ok( $argval->SetPBString( $pbstring ), 'eq', PBX_OK, 'set PBString');
#~ $session->ReleaseValue( $argval->get );

$argval = new Powerbuilder::Value( $session->AcquireValue( $argvl->get ) );
cmp_ok( $argval->SetReal(4.8), 'eq', PBX_OK, 'set real');
$session->ReleaseValue( $argval->get );

$argval = new Powerbuilder::Value( $session->AcquireValue( $argvl->get ) );
cmp_ok( $argval->SetString("48"), 'eq', PBX_OK, 'set string');
$session->ReleaseValue( $argval->get );

$argval = new Powerbuilder::Value( $session->AcquireValue( $argvl->get ) );
cmp_ok( $argval->SetUint(48), 'eq', PBX_OK, 'set uint');
$session->ReleaseValue( $argval->get );

$argval = new Powerbuilder::Value( $session->AcquireValue( $argvl->get ) );
cmp_ok( $argval->SetUlong(48), 'eq', PBX_OK, 'set ulong');
$session->ReleaseValue( $argval->get );
$session->FreeCallInfo( $cinfo->get() );