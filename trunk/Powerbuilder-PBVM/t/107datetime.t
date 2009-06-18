use Test::More tests => 13;
BEGIN { use_ok('Powerbuilder::PBVM') };

my $session = new Powerbuilder::PBVM;
cmp_ok( ref($session), 'eq', 'Powerbuilder::PBVM',    'constructor');
chdir './t';
my $r = $session->CreateSession( $session->project('scriptingpb.pbt') );
chdir '..';
cmp_ok( $r, 'eq', 0, 'open session');

my $pbvar = $session->NewDateTime();
cmp_ok( $pbvar ,'ne', 0,    'constructor');
cmp_ok( $session->SetDateTime($pbvar, 2009, 5, 31, 9, 6, 12.1) ,'==', 0,    'setter');
my $refstr = $session->GetDateTimeString($pbvar);
#may be a local depend result... 
#TODO: adapt depending on locales.
cmp_ok( $session->unref($refstr) ,'eq', '31/05/2009 09:06:12', 'getter');
$session->ReleaseDateTimeString( $refstr );
SKIP: {
	skip "write the Spliter (SplitDateTime) in XS which return a list with year, month, day,...", 7 unless
		$session->can('SplitDateTime');
	
	my ($year, $month, $day,$hour, $minute, $second) = (0,0,0,0,0,0.0);
	cmp_ok( $session->SplitDateTime($pbvar, $year, $month, $day, $hour, $minute, $second), '==', 0, 'split datetime');
	cmp_ok( $year, '==', 2009, 'split datetime');
	cmp_ok( $month, '==', 5, 'split datetime');
	cmp_ok( $day, '==', 31, 'split datetime');
	cmp_ok( $hour, '==', 9, 'split datetime');
	cmp_ok( $minute, '==', 6, 'split datetime');
	cmp_ok( $second - 12.1, '<=', 0.1, 'split datetime');
}