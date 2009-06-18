use Test::More tests => 17;

BEGIN { use_ok('Powerbuilder::PBVM') };

my $session = new Powerbuilder::PBVM;
cmp_ok( ref($session) ,'eq', 'Powerbuilder::PBVM',    'constructor');

my $r = $session->CreateSession("scriptingpb", "t/scriptingpb.pbl", 1);
cmp_ok( $r ,'eq', 0, 'open session');

my ($pbclass, $pbmid, $pbgroup);
$pbgroup = $session->FindGroup("user_exception_pspp", 6); #pbgroup_userobject constant
$pbclass = $session->FindClass( $pbgroup, "user_exception_pspp");
my $pbobject = $session->NewObject( $pbclass );
$pbmid = $session->GetMethodID( $pbclass, "setmessage", 0, "QS"); #constant PBRT_FUNCTION = 0

my $ci = new Powerbuilder::CallInfo;
$session->InitCallInfo( $pbclass, $pbmid, $ci->get() );
my $arg = new Powerbuilder::Arguments( $ci->Args() );
cmp_ok( $arg->GetCount(), '==', 1, 'get count' );
my $pbarg = $arg->GetAt(0);
cmp_ok( $pbarg, '!=', 0, 'get at' );
$session->FreeCallInfo( $ci->get() );

#Now must test the Add<type>Argument...
$ci = new Powerbuilder::CallInfo;
$session->InitCallInfo( $pbclass, $pbmid, $ci->get() );
cmp_ok( $session->AddStringArgument( $ci->get(), 'just a perl arg'), '==', 0, 'add string');
cmp_ok( $session->AddBoolArgument( $ci->get(), 1, 0 ), '==', 0, 'add bool');
cmp_ok( $session->AddByteArgument( $ci->get(), 1, 0 ), '==', 0, 'add byte');
cmp_ok( $session->AddCharArgument( $ci->get(), '1', 0 ), '==', 0, 'add char');
cmp_ok( $session->AddDoubleArgument( $ci->get(), 1.1, 0 ), '==', 0, 'add double');
cmp_ok( $session->AddRealArgument( $ci->get(), 1.3, 0 ), '==', 0, 'add real');
cmp_ok( $session->AddIntArgument( $ci->get(), 1, 0 ), '==', 0, 'add int');
cmp_ok( $session->AddUintArgument( $ci->get(), 1, 0 ), '==', 0, 'add uint');
cmp_ok( $session->AddLongArgument( $ci->get(), 1, 0 ), '==', 0, 'add long');
cmp_ok( $session->AddUlongArgument( $ci->get(), 1, 0 ), '==', 0, 'add ulong');
my $pbstr = $session->NewString("test perl");
cmp_ok( $session->AddPBStringArgument( $ci->get(), $pbstr, 0 ), '==', 0, 'add pbstring');
$arg = new Powerbuilder::Arguments( $ci->Args() );
cmp_ok( $arg->GetCount(), '==', 12, 'get count' );