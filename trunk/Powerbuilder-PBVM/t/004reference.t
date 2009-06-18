use Test::More tests => 3 + 1;

BEGIN { use_ok('Powerbuilder::PBVM') };

my $session = new Powerbuilder::PBVM;
cmp_ok( ref($session) ,'eq', 'Powerbuilder::PBVM',    'constructor');

my $r = $session->CreateSession("scriptingpb", "t/scriptingpb.pbl", 1);
cmp_ok( $r ,'eq', 0, 'open session');

SKIP:{
	skip "session reference not implemented.", 1
		unless $session->can('AddLocalRef');

	my ($pbclass, $pbmid, $pbgroup);
	$pbgroup = $session->FindGroup("user_exception_pspp", 6); #pbgroup_userobject constant
	$pbclass = $session->FindClass( $pbgroup, "user_exception_pspp");
	my $pbobject = $session->NewObject( $pbclass );

	$session->AddLocalRef( $pbobject );
	$session->RemoveLocalRef( $pbobject );
		
	$session->PushLocalFrame();
	my $pbstring = $session->NewString("tmp");
	#All Decimal, Objet or String allocated here ...
	$session->PopLocalFrame();
	# ... should be destroyed !
	#MUST invoke the system.isValid( ? ) function !
	cmp_ok( defined($session->GetString( $pbstring )), '==', 0, 'Push/Pop local frame' );
	
	$session->AddGlobalRef( $pbobject );
	$session->RemoveGlobalRef( $pbobject );

}