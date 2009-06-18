use Test::More tests => 9;
BEGIN { use_ok('Powerbuilder::PBVM') };

my $session = new Powerbuilder::PBVM;
cmp_ok( ref($session), 'eq', 'Powerbuilder::PBVM',    'constructor');

my $r = $session->CreateSession("scriptingpb", "t/scriptingpb.pbl", 1);
cmp_ok( $r, 'eq', 0, 'open session');

				#$session->GetCurrGroup();
my $currgroup = $session->FindGroup("scriptingpb", 0); #pbgroup_application constant

cmp_ok( $currgroup, '!=', 0, 'get current group' );

my $id = $session->GetSharedVarID($currgroup, "ss_var" );
cmp_ok( $id, 'ne', 0,    'get var id');
my $type = $session->GetSharedVarType( $currgroup, $id );
#todo: implement constants for enumerated pb_vartypes
cmp_ok( $type, '==', 6,  'get var type');

cmp_ok( $session->IsSharedVarNull($currgroup, $id), '==', 0, 'var is null');
cmp_ok( $session->IsSharedVarObject($currgroup, $id), '==', 0, 'var is object');
cmp_ok( $session->IsSharedVarArray($currgroup, $id), '==', 0, 'var is array');