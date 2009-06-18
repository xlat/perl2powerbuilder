use Test::More tests => 10;
BEGIN { use_ok('Powerbuilder::PBVM') };

my $session = new Powerbuilder::PBVM;
cmp_ok( ref($session), 'eq', 'Powerbuilder::PBVM',    'constructor');
chdir './t';
my $r = $session->CreateSession( $session->project('scriptingpb.pbt') );
chdir '..';
cmp_ok( $r, 'eq', 0, 'open session');

my $pbvar = $session->NewDate();
cmp_ok( $pbvar ,'ne', 0,    'constructor');
cmp_ok( $session->SetDate($pbvar, 2009, 5, 31) ,'==', 0,    'setter');
my $refstr = $session->GetDateString($pbvar);
#may be a local depend result... 
#TODO: adapt depending on locales.
cmp_ok( $session->unref($refstr) ,'eq', '31/05/2009', 'getter');
$session->ReleaseDateString( $refstr );
my ($year, $month, $day) = (0,0,0);
SKIP: {
	skip "write the Spliter (SplitDate) in XS which return a list with year, month, day.", 4 unless
		$session->can('SplitDate');
	cmp_ok( $session->SplitDate($pbvar, $year, $month, $day), '==', 0, 'split date');
	cmp_ok( $year, '==', 2009, 'split date');
	cmp_ok( $month, '==', 5, 'split date');
	cmp_ok( $day, '==', 31, 'split date');
}