use Test::More tests => 7;
BEGIN { use_ok('Powerbuilder::PBVM') };

my $session = new Powerbuilder::PBVM;
cmp_ok( ref($session) ,'eq', 'Powerbuilder::PBVM',    'constructor');

my $r = $session->CreateSession("scriptingpb", "t/scriptingpb.pbl", 1);
cmp_ok( $r ,'eq', 0, 'open session');

my $pbstring = $session->NewString("Titi");
cmp_ok( $pbstring ,'ne', 0,    'constructor');
cmp_ok( $session->GetString($pbstring) ,'eq', 'Titi',    'getter');
$session->SetString($pbstring, 'geni');
cmp_ok( $session->GetString($pbstring) ,'eq', 'geni',    'setter');
cmp_ok( $session->GetStringLength($pbstring) ,'==', 4,  'length');

