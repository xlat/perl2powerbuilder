use Test::More tests => 12;

BEGIN { use_ok('Powerbuilder::PBVM') };

my $session = new Powerbuilder::PBVM;
cmp_ok( ref($session), 'eq', 'Powerbuilder::PBVM',    'constructor');
chdir './t';
my $r = $session->CreateSession( $session->project('scriptingpb.pbt') );
chdir '..';
cmp_ok( $r, 'eq', 0, 'open session');
my $id = $session->GetGlobalVarID("ga_var_any" );
cmp_ok( $id, '!=', 0,    'get var id');

cmp_ok( $session->IsGlobalVarNull($id), 'eq', 0, 'is global var null, on any');
cmp_ok($session->IsGlobalVarObject( $id), 'eq', 0, 'is global var object');
cmp_ok($session->GetGlobalVarType($id), 'eq', pbvalue_any, 'get global var type');

my $isnull = 0;
my $pbvalue = $session->GetPBAnyGlobalVar($id, $isnull);
cmp_ok( $pbvalue ,'ne', 0,    'any getter');
cmp_ok( $isnull ,'ne', 0,    'any getter (isnull)');
my $value = new Powerbuilder::Value( $pbvalue );
cmp_ok( ref($value) ,'eq', 'Powerbuilder::Value',    'any (package)');
$value->SetString('test');
cmp_ok( $isnull ,'ne', 0,    'any (isnull) constructor');
cmp_ok( $value->GetType() ,'==', 6,    'get type');