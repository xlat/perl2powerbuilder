use Test::More tests => 3+4;

BEGIN { use_ok('Powerbuilder::PBVM') };

my $session = new Powerbuilder::PBVM;
cmp_ok( ref($session) ,'eq', 'Powerbuilder::PBVM',    'constructor');

my $r = $session->CreateSession("scriptingpb", "t/scriptingpb.pbl", 1);
cmp_ok( $r ,'eq', 0, 'open session');

SKIP:{
	skip "Exception not implemented.", 4
		unless $session->can('HasExceptionThrown');

	cmp_ok( $session->HasExceptionThrown(), '==', 0, 'Has Exception');
	
	my ($pbclass, $pbmid, $pbgroup);
	$pbgroup = $session->FindGroup("user_exception_pspp", 6); #pbgroup_userobject constant
	$pbclass = $session->FindClass( $pbgroup, "user_exception_pspp");
	my $pbexception = $session->NewObject( $pbclass );
	
	$session->ThrowException($pbexception);
	$session->ProcessPBMessage();
	cmp_ok( $session->HasExceptionThrown(), '!=', 0, 'Throw Exception');
	
	$pbexception = $session->GetException();
	cmp_ok( $pbexception, '!=', 0, 'Get Exception');
	
	$session->ClearException();
	cmp_ok( $session->HasExceptionThrown(), '==', 0, 'Clear Exception');
	
	
	
}