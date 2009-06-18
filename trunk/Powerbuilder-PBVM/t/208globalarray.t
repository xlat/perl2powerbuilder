use Test::More tests => 3+3;

BEGIN { use_ok('Powerbuilder::PBVM') };

my $session = new Powerbuilder::PBVM;
cmp_ok( ref($session), 'eq', 'Powerbuilder::PBVM',    'constructor');
chdir './t';
my $r = $session->CreateSession( $session->project('scriptingpb.pbt') );
chdir '..';
cmp_ok( $r, 'eq', 0, 'open session');

my $id = $session->GetGlobalVarID("gsa_var" );
cmp_ok( $id, 'ne', 0, 'get var id');

my $pbarray = $session->GetArrayGlobalVar( $id, my $isnull );
cmp_ok( $pbarray, '!=', 0, 'get global array');

$session->PushLocalFrame();

my $pbnewarray = $session->NewUnboundedSimpleArray( pbvalue_string );

cmp_ok( $session->SetArrayGlobalVar( $id, $pbnewarray ), 'eq', PBX_OK, 'set global array');

$session->PopLocalFrame();