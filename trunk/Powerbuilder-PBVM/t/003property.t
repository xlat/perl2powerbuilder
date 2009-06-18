use Test::More tests => 6;

BEGIN { use_ok('Powerbuilder::PBVM') };

my $session = new Powerbuilder::PBVM;
cmp_ok( ref($session) ,'eq', 'Powerbuilder::PBVM',    'constructor');

my $r = $session->CreateSession("scriptingpb", "t/scriptingpb.pbl", 1);
cmp_ok( $r ,'eq', 0, 'open session');

SKIP:{
	skip "session property not implemented.", 2 
		unless $session->can('SetProp');
	my $pbvar = $session->NewString('Test perl');
	$session->SetProp( 'perl', $pbvar );
	my $prop = $session->GetProp( 'perl' );
	cmp_ok( $prop, 'ne', 0, 'setter / getter');
	cmp_ok( $session->GetString($prop), 'eq', 'Test perl', 'setter / getter');
	$session->RemoveProp('perl');
	$prop = $session->GetProp( 'perl' );
	cmp_ok( $prop, 'eq', 0, 'remove prop');
}