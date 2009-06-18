use Test::More tests => 3+17;

BEGIN { use_ok('Powerbuilder::PBVM') };
my $session = new Powerbuilder::PBVM;
cmp_ok( ref($session), 'eq', 'Powerbuilder::PBVM',    'constructor');
chdir './t';
my $r = $session->CreateSession( $session->project('scriptingpb.pbt') );
chdir '..';
cmp_ok( $r, 'eq', 0, 'open session');

$session->PushLocalFrame();

my $pbarray_bounded = $session->NewBoundedSimpleArray( pbvalue_int, [1,2,3,5] );
cmp_ok( $pbarray_bounded, '!=', 0, 'new bounded simple array');

cmp_ok( $session->GetArrayLength( $pbarray_bounded ), '==', (2-1+1)*(5-3+1), 'get array length' );

my $arrayInfoPtr = $session->GetArrayInfo( $pbarray_bounded );
cmp_ok( $arrayInfoPtr, '!=', 0, 'get array info');
my $arrayInfo = new Powerbuilder::ArrayInfo($arrayInfoPtr);
cmp_ok( $arrayInfo, '!=', 0, 'ArrayInfo new');
cmp_ok( $arrayInfo->get, '!=', 0, 'ArrayInfo get()');
cmp_ok( $arrayInfo->IsBoundedArray, '!=', 0, 'ArrayInfo Is Bounded array');
cmp_ok( $arrayInfo->valueType, '==', pbvalue_int, 'ArrayInfo value type');
cmp_ok( $arrayInfo->numDimensions, '==', 2, 'ArrayInfo num dimensions');
cmp_ok( $arrayInfo->ArrayBoundLower(1), '==', 3, 'ArrayInfo Lowerbound');
cmp_ok( $arrayInfo->ArrayBoundUpper(1), '==', 5, 'ArrayInfo Upperbound');
cmp_ok( $session->IsArrayItemNull($pbarray_bounded, [1,3]) , '==', 0, 'Is array item null');
$session->SetArrayItemToNull($pbarray_bounded, [1,3]);
cmp_ok( $session->IsArrayItemNull($pbarray_bounded, [1,3]) , '!=', 0, 'Set array item null');

cmp_ok( $session->GetArrayItemType($pbarray_bounded, [1,3]), '==', pbvalue_int, 'get array item type');

my $isNull = 0;
#should put a SetInt test here !
cmp_ok( $session->SetIntArrayItem($pbarray_bounded, [1,3], 79), '==', PBX_OK, 'set array int item');
cmp_ok( $session->GetIntArrayItem($pbarray_bounded, [1,3], $isNull), '==', 79, 'get array int item');

#Todo : test this following subs (getter + setter)
my $err = 0;
foreach my $pbtype ( qw(Byte Long Real Double Dec String Bool Uint Ulong
						Blob Date Time DateTime Char Object ) ){
	$err ++ unless $session->can("Get${pbtype}ArrayItem");
	$err ++ unless $session->can("Set${pbtype}ArrayItem");
}
cmp_ok( $err, '==', 0, 'array getters and setters set.');
#~ GetByteArrayItem
#~ GetLongArrayItem
#~ GetRealArrayItem
#~ GetDoubleArrayItem
#~ GetDecArrayItem
#~ GetStringArrayItem
#~ GetBoolArrayItem
#~ GetUintArrayItem
#~ GetUlongArrayItem
#~ GetBlobArrayItem
#~ GetDateArrayItem
#~ GetTimeArrayItem
#~ GetDateTimeArrayItem
#~ GetCharArrayItem
#~ #GetLongLongArrayItem
#~ GetObjectArrayItem

cmp_ok( $session->ReleaseArrayInfo( $arrayInfo->get() ), '==', 0, 'release array info');

$session->PopLocalFrame();