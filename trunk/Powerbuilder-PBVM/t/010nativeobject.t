use Test::More skip_all => "Nativeobject not implemented yet.";

#~ use Test::More tests => 3;

BEGIN { use_ok('Powerbuilder::PBVM') };
SKIP:{
	skip "NativeObject not implemented.", 2 if 1;

	my $session = new Powerbuilder::PBVM;
	cmp_ok( ref($session) ,'eq', 'Powerbuilder::PBVM',    'constructor');

	my $r = $session->CreateSession("scriptingpb", "t/scriptingpb.pbl", 1);
	cmp_ok( $r ,'eq', 0, 'open session');
}