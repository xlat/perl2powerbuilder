use Test::More tests => 7;
BEGIN { use_ok('Powerbuilder::PBVM') };

my $session = new Powerbuilder::PBVM;
ok( ref($session) eq 'Powerbuilder::PBVM',    'constructor');
chdir './t';
my $r = $session->CreateSession( $session->project('scriptingpb.pbt') );
chdir '..';
ok( $r eq 0, 'open session');

my $blobdata = "my blob";
my $blob = $session->NewBlob($session->ref($blobdata), 8);
cmp_ok( $blob ,'ne', 0,    'constructor');
my $ref = $session->GetBlob($blob);
$ref = $session->unref( $ref );
cmp_ok( $ref ,'eq', $blobdata,    'getter');
$blobdata = reverse( $blobdata );
$session->SetBlob($blob, $session->ref($blobdata), length($blobdata)+1);
$ref = $session->GetBlob($blob);
$ref = $session->unref( $ref );
cmp_ok( $ref ,'eq', $blobdata,    'setter');
cmp_ok( $session->GetBlobLength($blob) ,'eq', (length($blobdata)+1), 'length');
