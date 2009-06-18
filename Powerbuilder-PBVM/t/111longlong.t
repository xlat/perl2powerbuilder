use Test::More skip_all => "Longlong not implemented (in perl).";

#~ use Test::More tests => 3+3;

BEGIN { use_ok('Powerbuilder::PBVM') };

my $session = new Powerbuilder::PBVM;
ok( ref($session) eq 'Powerbuilder::PBVM',    'constructor');
chdir './t';
my $r = $session->CreateSession( $session->project('scriptingpb.pbt') );
chdir '..';
ok( $r eq 0, 'open session');

my $longlong = $session->NewLongLong();
cmp_ok( $longlong ,'ne', 0,    'constructor');
cmp_ok( $session->SetLonglong($longlong, "1235") ,'==', 0,    'setter');
cmp_ok( $session->GetLonglong($longlong) ,'eq', '1235', 'getter');
