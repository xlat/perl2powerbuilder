use Test::More tests => 5;
BEGIN { use_ok('Powerbuilder::PBVM') };

my $session = new Powerbuilder::PBVM;
cmp_ok( ref($session), 'eq', 'Powerbuilder::PBVM',    'constructor');

my $r = $session->CreateSession("scriptingpb", "t/scriptingpb.pbl", 1);
cmp_ok( $r, 'eq', 0, 'open session');

cmp_ok( $session->GetEnumItemValue("band","footer" ), 'eq', 2,    'get value');
cmp_ok( $session->GetEnumItemName("band", 0 ), 'eq', 'detail',    'get name');