use Test::More tests => 3 + 1 + 11*13 +7;
BEGIN { 
	use_ok('Powerbuilder');
	use_ok('Powerbuilder::PBVM');
	use_ok('Powerbuilder::Variable');
	chdir './t' ;
};

#########################
my $pb = new Powerbuilder( 'scriptingpb.pbt' );
cmp_ok( ref( $pb ), 'eq', 'Powerbuilder', 'openning session' );

sub isnumeric{ 	
	return $pb->VM->doesScalarContainNumber( $_[0] );
}

#each call run 10 tests
my $hit = 1;
sub test_handle{ defined($_[0]) && $_[0]>0 }
sub test_package_var{ defined($_[0]) && ref($_[0]) eq 'Powerbuilder::Variable' }
sub variable_tests{
	my ($tname, $var) = (shift, shift);
	cmp_ok( ref $var, 'eq', 'Powerbuilder::Variable', "$tname: empty constructor ($hit)");
	
	foreach $method ( qw/ scope isnull isobject isenum isstruct 
						isarray issimplearray datatypeof pbvalue value/ ){
		my $value = shift;
		#~ print "Testing for $method using value `$value` comparing with `".$var->$method()."`\n";
		if(ref($value) =~ /^CODE/){
			ok( $value->( $var->$method() ), "$tname: $method ($hit) ");
		}
		elsif(!defined $value){
			ok( !defined $var->$method(), "$tname: $method ($hit) ");
		}
		elsif(isnumeric($value)){
			cmp_ok( $var->$method(), '==', $value, "$tname: $method ($hit) ");
		}
		else{
			cmp_ok( $var->$method(), 'eq', $value, "$tname: $method ($hit) ");
		}
	}
	$hit++;
}

my $var;
# Tests for an empty variable
$var = new Powerbuilder::Variable;
variable_tests( "Empty var", $var, 'anonymous', 1, 0, 0, 0, 0, 0, -1, undef, undef );
# Tests for a perl variables
$var = new Powerbuilder::Variable( 1979 );
variable_tests( "Perl ulong", $var, 'anonymous', 0, 0, 0, 0, 0, 0, pbvalue_ulong, 1979, 1979 );
$var = new Powerbuilder::Variable( -1979 );
variable_tests( "Perl long", $var, 'anonymous', 0, 0, 0, 0, 0, 0, pbvalue_long, -1979, -1979 );
$var = new Powerbuilder::Variable( 'a perl string' );
variable_tests( "Perl string", $var, 'anonymous', 0, 0, 0, 0, 0, 0, pbvalue_string, \&test_handle, 'a perl string' );
$var = new Powerbuilder::Variable( 12.5 );
variable_tests( "Perl decimal", $var, 'anonymous', 0, 0, 0, 0, 0, 0, pbvalue_dec, \&test_handle, 12.5 );

# add test for new( type=> pbvalue_string, value => "test native string" );
$var = new Powerbuilder::Variable( type=>pbvalue_boolean, value=> 1 );
variable_tests( "Perl 'boolean'", $var, 'anonymous', 0, 0, 0, 0, 0, 0, pbvalue_boolean, 1, 1 );
$var = new Powerbuilder::Variable( type=>pbvalue_char, value=> 'A' );
variable_tests( "Perl 'char'", $var, 'anonymous', 0, 0, 0, 0, 0, 0, pbvalue_char, 'A', 'A' );
my $pbblob = $pb->VM->NewBlob( $pb->VM->ref('This is a Blob'), length('This is a Blob') );
$var = new Powerbuilder::Variable( type=>pbvalue_blob, value=> $pbblob );
variable_tests( "Perl 'blob'", $var, 'anonymous', 0, 0, 0, 0, 0, 0, pbvalue_blob, \&test_handle, 'This is a Blob' );
$var = new Powerbuilder::Variable( type=>pbvalue_real, value=> 1.3547 );
variable_tests( "Perl 'real'", $var, 'anonymous', 0, 0, 0, 0, 0, 0, pbvalue_real, 1.3547, 1.3547);
$var = new Powerbuilder::Variable( type=>pbvalue_double, value=> 531.321 );
variable_tests( "Perl 'double'", $var, 'anonymous', 0, 0, 0, 0, 0, 0, pbvalue_double, 531.321, 531.321 );

#TODO: special PBType: time, date, datetime, object, struct, enum, longlong=>not implemented! any(?)
#we could add some sugar for (time, date, datetime) :
#	$var->year() 
#	$var->hour()
#we could add sugar for enum too : $var->name (when|if possible)

my $var2 = new Powerbuilder::Variable( "a string" );
$var = new Powerbuilder::Variable( $var2 );
variable_tests( "Perl 'Powerbuilder::Variable'", $var, 'anonymous', 0, 0, 0, 0, 0, 0, pbvalue_string, \&test_handle, 'a string' );

# add test for new ( Powerbuilder::Value )
#add Array tests:
# add test for new( [ Powerbuilder::Variable, Powerbuilder::Variable, ... ] )
# add test for new( [ Powerbuilder::Variable, Powerbuilder::Value, (type=>...,value=>...) ] )

$var = new Powerbuilder::Variable( class=>'nv_proto' );
variable_tests( "Perl 'new class'", $var, 'anonymous', 0, 1, 0, 0, 0, 0, $var->classid, \&test_handle, \&test_package_var );
#or could use
$var = create Powerbuilder::Variable( 'nv_proto' );
variable_tests( "Perl 'create class'", $var, 'anonymous', 0, 1, 0, 0, 0, 0, $var->classid, \&test_handle, \&test_package_var );
cmp_ok( $var->FieldCount, '==', 4+1, 'FieldCount' );	#4 fields + proxyname !
cmp_ok( ref($var->GetField('is_msg')), 'eq', 'Powerbuilder::Variable', 'GetField' );
cmp_ok( $var->GetField('is_msg')->value, 'eq', 'Welcome !', 'is_msg value' );
cmp_ok( $var->GetFieldName(0), 'eq', 'proxyname', 'first field name' );

#todo: field setter
$var->SetField('is_msg', 'Thank you!');
cmp_ok( $var->GetField('is_msg')->value, 'eq', 'Thank you!', 'is_msg setted value' );
#todo: autoload / fields
cmp_ok( $var->is_msg->value, 'eq', 'Thank you!', 'is_msg autoload value' );
cmp_ok( $var->is_msg, 'eq', 'Thank you!', 'is_msg autoload + toString operator' );
#~ cmp_ok( $var->Invoke('test2', 30, 1), '==', 31, 'Invoke method' );
#~ cmp_ok( $var->test2(30, 1), '==', 31, 'autoload method' );

#Others things to implement/tests:
#- numeric operators +, -, *, /, ==, !=, >=, <=, <, >, ^
#- string operators ., eq, ne, lt, gt, le, ge
#- array operators [ index ] getter / setter
#- object -> methods and fields
#	be care: a Variable of type pbvalue_object need a special AUTOLOAD !

END{
		chdir '..';
	};