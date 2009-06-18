use Test::More tests => 14;

BEGIN { use_ok('Powerbuilder::PBVM') };

my $session = new Powerbuilder::PBVM;
cmp_ok( ref($session) ,'eq', 'Powerbuilder::PBVM',    'constructor');

my $r = $session->CreateSession("scriptingpb", "t/scriptingpb.pbl", 1);
cmp_ok( $r ,'eq', 0, 'open session');


my ($pbclass, $pbgroup);
$pbgroup = $session->FindGroup("user_exception_pspp", 6); #pbgroup_userobject constant
cmp_ok( $pbgroup, 'ne', 0, 'find group' );
$pbclass = $session->FindClass( $pbgroup, "user_exception_pspp");
cmp_ok( $pbclass, 'ne', 0, 'find class' );
my $pbobject = $session->NewObject( $pbclass );
cmp_ok( $pbobject, 'ne', 0, 'new object' );

SKIP:{
	use Test::Harness;
	diag "FindClassByClassID not enought documentation about it" if $Test::Harness::VERSION>2.56;
	skip "FindClassByClassID not enought documentation about it", 1 if 1;
	cmp_ok( 0, 'ne', 0, 'FindClassByClassID' );
}

my $class = $session->GetClass( $pbobject );
cmp_ok( $class, 'eq', $pbclass, 'get class' );

cmp_ok( $session->GetClassName( $pbclass ), 'eq', 'user_exception_pspp', 'Get class name' );
cmp_ok( $session->GetCurrGroup( ), 'ne', 0, 'Get curr group' );
cmp_ok( $session->GetSuperClass( $pbclass ), 'ne', 0, 'Get super class' );
cmp_ok( $session->GetSystemClass( $pbclass ), 'ne', 0, 'Get system class' );
cmp_ok( $session->GetSystemGroup( ), 'ne', 0, 'Get system group' );
cmp_ok( $session->IsAutoInstantiate( $pbclass ), 'eq', 0, 'is auto instantiate' );