use Test::More tests => 10;
BEGIN { use_ok('Powerbuilder::PBVM') };

my $session = new Powerbuilder::PBVM;
cmp_ok( ref($session), 'eq', 'Powerbuilder::PBVM',    'constructor');
chdir './t';
my $r = $session->CreateSession( $session->project('scriptingpb.pbt') );
chdir '..';
cmp_ok( $r, 'eq', 0, 'open session');

my $pbvar = $session->NewTime();
cmp_ok( $pbvar ,'ne', 0,    'constructor');
cmp_ok( $session->SetTime($pbvar, 9, 6, 12.1) ,'==', 0,    'setter');
my $refstr = $session->GetTimeString($pbvar);
cmp_ok( $session->unref($refstr) ,'eq', '09:06:12', 'getter');
$session->ReleaseTimeString( $refstr );
my ($hour, $minute, $second) = (0,0,0.0);
SKIP: {
	skip "write the Spliter (SplitTime) in XS which return a list with hour, minute, second.", 4 unless
		$session->can('SplitTime');

	cmp_ok( $session->SplitTime($pbvar, $hour, $minute, $second), '==', 0, 'split time');
	cmp_ok( $hour, '==', 9, 'split time');
	cmp_ok( $minute, '==', 6, 'split time');
	cmp_ok( $second - 12.1, '<=', 0.1, 'split time');
}