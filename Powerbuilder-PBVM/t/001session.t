use Test::More tests => 7;
BEGIN { 
	use_ok('Powerbuilder::PBVM');
	chdir './t';
};

my $session = new Powerbuilder::PBVM;
ok( ref($session) eq 'Powerbuilder::PBVM',    'constructor');

my $r = $session->CreateSession("scriptingpb", "scriptingpb.pbl;ancestors.pbl", 2);
ok( $r eq 0, 'open session');
$session->ReleaseSession();

my ($app, $libs, $nblibs) = $session->project('scriptingpb.pbt');
cmp_ok( $app, 'eq', 'scriptingpb', 'get application from .pbt' );
cmp_ok( $libs, 'eq', 'scriptingpb.pbl;ancestors.pbl', 'get library list from .pbt' );
cmp_ok( $nblibs, '==', 2, 'get lib count from .pbt' );

$r = $session->CreateSession( $app, $libs, $nblibs );
cmp_ok( $r, '==', PBX_OK, 'createsession' );
$session->ReleaseSession();

$r = $session->RunApplication( $app, $libs, $nblibs, '--test' );
cmp_ok( $r, '==', PBX_OK, 'run application' );
$session->ReleaseSession();


END{
	chdir '..';
};