use Test::More skip_all => "Longlong not implemented (in perl).";

#~ use Test::More tests => 1+5;

BEGIN { use_ok('Powerbuilder::PBVM') };

SKIP: {
	skip "Longlong are Not implemented yet.", 5;

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

}