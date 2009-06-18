use Test::More tests => 3+2;

BEGIN {
	chdir './t';
	use_ok('Powerbuilder::PBVM') 
	};

my $session = new Powerbuilder::PBVM;
cmp_ok( ref($session), 'eq', 'Powerbuilder::PBVM',    'constructor');
my $r = $session->CreateSession( $session->project('scriptingpb.pbt') );

cmp_ok( $r, 'eq', 0, 'open session');

#---------------------------------------
my $errors = 0;
my ($pbclass, $pbmid, $pbgroup);

foreach $obj ( qw/ nv_proto nv_autoinstantiate nv_non_autoinstantiate / ){
	$pbgroup = $session->FindGroup( $obj, pbgroup_userobject );
	$errors++, next unless $pbgroup;
	$pbclass = $session->FindClass( $pbgroup, $obj );
	$errors++, next unless $pbclass;
	$errors++ unless $session->NewObject( $pbclass );
}
cmp_ok( $errors, 'eq', 0, 'autoinstantiate, non-autoinstantiate user objects');

$errors = 0;
$pbgroup = $session->GetSystemGroup() or croak("GetSystemGroup failed");
$errors++ unless $pbgroup;
foreach my $obj ( qw/ ADOResultset	ListViewItem	TraceActivityNode
Application	mailFileDescription	TraceBeginEnd
ArrayBounds	mailMessage	TraceError
ClassDefinition	mailSession	TraceESQL
Connection	MDIClient	TraceFile
ConnectionInfo	Menu	TraceGarbageCollect
ContextInformation	MenuCascade	TraceLine
ContextKeyword	Message	TraceObject
CORBACurrent	OLEObject	TraceRoutine
CORBAObject	OLEStorage	TraceTree
CORBASystemException	OLEStream	TraceTreeError
CORBAUserException	OLETxnObject	TraceTreeESQL
DataStore	Pipeline	TraceTreeGarbageCollect
DataWindowChild	ProfileCall	TraceTreeLine
DynamicDescriptionArea	ProfileClass	TraceTreeNode
DynamicStagingArea	ProfileLine	TraceTreeRoutine
EnumerationDefinition	ProfileRoutine	TraceTreeUser
EnumerationItemDefinition	Profiling	TraceUser
Environment	ResultSet	Transaction
Error	ResultSets	TransactionServer
ErrorLogging	RuntimeError	TreeViewItem
Exception	ScriptDefinition	TypeDefinition
grAxis	SimpleTypeDefinition	UserObject
grDispAttr	SSLCallBack	VariableCardinalityDefinition
Inet	SSLServiceProvider	VariableDefinition
InternetResult	Throwable	Window
JaguarORB	Timing / ){
	#~ print "\n\t$obj";
	next if $obj =~ /^corba/i; #skipping instantiate CORBA objects...
	$pbclass = $session->FindClass( $pbgroup, $obj);
	$errors++, next unless $pbclass;
	$errors++ unless $session->NewObject( $pbclass );
}
cmp_ok( $errors, 'eq', 0, 'system objects');

END{ 
	chdir '..'; 
	}