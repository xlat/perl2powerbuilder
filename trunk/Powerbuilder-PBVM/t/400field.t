use Test::More tests => 3+12;
#~ use Test::More skip_all => "fields tests are not writted yet !";

BEGIN {
	chdir './t';
	use_ok('Powerbuilder::PBVM') 
	};


my $session = new Powerbuilder::PBVM;
cmp_ok( ref($session) ,'eq', 'Powerbuilder::PBVM',    'constructor');

my $r = $session->CreateSession( Powerbuilder::PBVM::project "scriptingpb.pbt");
cmp_ok( $r ,'eq', 0, 'open session');


#fields tests 
#~ 400fields.t
#~ 401fieldchar.t ...
#4 getter/setter/setnull/isnull with Fields ( for each datatype ! )

# new object
my ($pbclass, $pbmid, $pbgroup);
$pbgroup = $session->FindGroup("nv_proto", pbgroup_userobject) or die "bad pbgroup id !";
$pbclass = $session->FindClass( $pbgroup, "nv_proto") or die "bad pbclass id !";
my $pbobj = $session->NewObject( $pbclass );
cmp_ok( $pbobj, 'ne', 0, 'new object');

# get field id
my $fid = $session->GetFieldID( $pbclass, "is_msg" );
cmp_ok( $fid, 'ne', kUndefinedFieldID, 'get field id');

# get field type
cmp_ok( $session->GetFieldType( $pbclass, $fid), 'eq', pbvalue_string, 'get field type');

# is object
cmp_ok( $session->IsFieldObject( $pbclass, $fid), 'eq', 0, 'is field object');

# is array
cmp_ok( $session->IsFieldArray( $pbclass, $fid), 'eq', 0, 'is field array');

# is null ?
cmp_ok( $session->IsFieldNull( $pbobj, $fid ), 'eq', 0, 'is field null' );

# setnull
$session->SetFieldToNull( $pbobj, $fid );
cmp_ok( $session->IsFieldNull( $pbobj, $fid ), 'ne', 0, 'set field null' );

# num of fields
cmp_ok( $session->GetNumOfFields( $pbclass ), 'eq', 3+1, 'number of fields' );

# name of field
cmp_ok( $session->GetFieldName( $pbclass, 1 ), 'eq', 'priv_is_name', 'get field name' );

# update field
$pbclass = $session->FindClass( $session->GetSystemGroup(), "window") or die "bad pbclass id !";
$pbobj = $session->NewObject( $pbclass ) or die "can't instantiate window object !";
$fid = $session->GetFieldID( $pbclass, "visible" );
$session->SetBoolField( $pbobj, $fid, 1 );
cmp_ok( $session->UpdateField( $pbobj, $fid ), 'eq', PBX_OK, 'update visual field' );

my $errors=0;
foreach ( qw/ GetArrayField GetBlobField GetBoolField 
GetByteField GetCharField GetDateField 
GetDateTimeField GetDecField GetDoubleField 
GetIntField GetLongField GetLongLongField 
GetObjectField GetRealField GetStringField 
GetTimeField GetUintField GetUlongField 
GetPBAnyField / ){
	if (/longlong/i) { diag "$_ not implemented"; next; }
	$errors++ unless $session->can($_);
}
cmp_ok( $errors, 'eq', 0, 'fields getters' );

$errors=0;
foreach ( qw/ SetArrayField SetBlobField SetBoolField 
SetByteField SetCharField SetDateField 
SetDateTimeField SetDecField SetDoubleField 
SetIntField SetLongField SetLongLongField 
SetObjectField SetPBStringField SetRealField 
SetStringField SetTimeField SetUintField SetUlongField / ){
	if (/longlong/i) { diag "$_ not implemented"; next; }
	$errors++ unless $session->can($_);
}
cmp_ok( $errors, 'eq', 0, 'fields setters' );


END{
	chdir '..';
	}