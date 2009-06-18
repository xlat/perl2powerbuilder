use Test::More tests => 8;
BEGIN { use_ok('Powerbuilder::PBVM') };

my $session = new Powerbuilder::PBVM;
cmp_ok( ref($session), 'eq', 'Powerbuilder::PBVM',    'constructor');

my $r = $session->CreateSession("scriptingpb", "t/scriptingpb.pbl", 1);
cmp_ok( $r, 'eq', 0, 'open session');

my $id = $session->GetGlobalVarID("gs_var" );
cmp_ok( $id, 'ne', 0,    'get var id');
my $type = $session->GetGlobalVarType( $id );
#todo: implement constants for enumerated pb_vartypes
cmp_ok( $type, '==', 6,    'get var type');

cmp_ok( $session->IsGlobalVarNull($id), '==', 0, 'var is null');
cmp_ok( $session->IsGlobalVarObject($id), '==', 0, 'var is object');
cmp_ok( $session->IsGlobalVarArray($id), '==', 0, 'var is array');