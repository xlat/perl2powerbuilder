use Test::More tests => 6;
BEGIN { use_ok('Powerbuilder::PBVM') };

my $session = new Powerbuilder::PBVM;
ok( ref($session) eq 'Powerbuilder::PBVM',    'constructor');
chdir './t';
my $r = $session->CreateSession( $session->project('scriptingpb.pbt') );
chdir '..';
ok( $r eq 0, 'open session');

my $dec = $session->NewDecimal();
cmp_ok( $dec ,'ne', 0,    'constructor');
cmp_ok( $session->SetDecimal($dec, "-123.5") ,'==', 0,    'setter');
my $refstr = $session->GetDecimalString($dec);
cmp_ok( $session->unref($refstr) ,'eq', '-123.5', 'getter');
$session->ReleaseDecimalString( $refstr );