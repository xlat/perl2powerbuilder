use Test::More tests => 8;
BEGIN { use_ok('Powerbuilder::PBVM') };

my $session = new Powerbuilder::PBVM;
cmp_ok( ref($session), 'eq', 'Powerbuilder::PBVM',    'constructor');

my $r = $session->CreateSession("scriptingpb", "t/scriptingpb.pbl", 1);
cmp_ok( $r, 'eq', 0, 'open session');

my $id = $session->GetGlobalVarID("gbl_var" );
cmp_ok( $id, 'ne', 0,    'get var id');

SKIP:{
	skip "Get<type>GlobalVar not yet implemented.", 4 
		unless $session->can('GetBlobGlobalVar');
	my $isnull;
	my $var = $session->GetBlobGlobalVar( $id, $isnull );
	cmp_ok( $var, 'ne', 0, 'var get');
	cmp_ok( $isnull, '==', 0, 'var get (isnull)');
	$session->SetGlobalVarToNull($id);
	cmp_ok( $session->IsGlobalVarNull($id), '==', 1, 'var set null');
	my $blobdata = "my blob";
	my $blob = $session->NewBlob( $session->ref($blobdata), length($blobdata)+1);
	cmp_ok( $session->SetBlobGlobalVar($id,$blob), '==', 0, 'var set ');
}