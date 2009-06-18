use Test::More tests => 3+9;

BEGIN { use_ok('Powerbuilder::PBVM') };

my $session = new Powerbuilder::PBVM;
cmp_ok( ref($session), 'eq', 'Powerbuilder::PBVM',    'constructor');
chdir './t';
my $r = $session->CreateSession( $session->project('scriptingpb.pbt') );
chdir '..';
cmp_ok( $r, 'eq', 0, 'open session');

my $id = $session->GetGlobalVarID("gex_var" );
cmp_ok( $id, 'ne', 0,    'get var id');

SKIP:{
	skip "Get<type>GlobalVar not yet implemented.", 4 
		unless $session->can('GetObjectGlobalVar');
	my $isnull;
	my $var = $session->GetObjectGlobalVar( $id, $isnull );
	cmp_ok( $var, 'eq', 0, 'var get');
	
	#create an object...
	my ($pbclass, $pbmid, $pbgroup);
	$pbgroup = $session->FindGroup("user_exception_pspp", pbgroup_userobject);
	cmp_ok($pbgroup, 'ne', 0, '(get group)');
	$pbclass = $session->FindClass( $pbgroup, "user_exception_pspp");
	cmp_ok($pbclass, 'ne', 0, '(get class)');
	my $pbexception = $session->NewObject( $pbclass );
	cmp_ok( $pbexception, 'ne', 0, '(new object)');
	cmp_ok( $session->SetObjectGlobalVar($id,$pbexception), '==', 0, 'var set ');	
	$var = $session->GetObjectGlobalVar( $id, $isnull );
	cmp_ok( $var, 'ne', 0, 'var get');
	cmp_ok( $isnull, '==', 0, 'var get (isnull)');
	$session->SetGlobalVarToNull($id);
	cmp_ok( $session->IsGlobalVarNull($id), '==', 1, 'var set null');
}