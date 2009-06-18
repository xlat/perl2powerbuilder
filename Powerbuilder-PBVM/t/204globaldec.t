use Test::More tests => 8;
BEGIN { use_ok('Powerbuilder::PBVM') };

my $session = new Powerbuilder::PBVM;
cmp_ok( ref($session), 'eq', 'Powerbuilder::PBVM',    'constructor');

my $r = $session->CreateSession("scriptingpb", "t/scriptingpb.pbl", 1);
cmp_ok( $r, 'eq', 0, 'open session');

my $id = $session->GetGlobalVarID("gdec_var" );
cmp_ok( $id, 'ne', 0,    'get var id');

SKIP:{
	skip "Get<type>GlobalVar not yet implemented.", 4 
		unless $session->can('GetDecGlobalVar');
	my $isnull = 0;
	my $var = $session->GetDecGlobalVar( $id, $isnull );
	cmp_ok( $var, 'ne', 0, 'var get ');
	cmp_ok( $isnull, '==', 0, 'var get (isnull)');
	$session->SetGlobalVarToNull($id);
	cmp_ok( $session->IsGlobalVarNull($id), '==', 1, 'var set null');
	my $pbdec = $session->NewDecimal();
	$session->SetDecimal( $pbdec, '0.5' );
	cmp_ok( $session->SetDecGlobalVar($id, $pbdec), '==', 0, 'var set');
}