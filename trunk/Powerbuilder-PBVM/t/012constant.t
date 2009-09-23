use Test::More tests => 2;
BEGIN { use_ok('Powerbuilder::PBVM') };


my $fail = 0;
foreach my $constname (qw(
	PBRT_ANY
	PBRT_EVENT
	PBRT_FUNCTION
	PBX_E_ARRAY_INDEX_OUTOF_BOUNDS
	PBX_E_BUILD_GROUP_FAILED
	PBX_E_CAN_NOT_LOCATE_APPLICATION
	PBX_E_GET_PBVM_FAILED
	PBX_E_INVALID_ARGUMENT
	PBX_E_INVALID_METHOD_ID
	PBX_E_INVOKE_FAILURE
	PBX_E_INVOKE_METHOD_AMBIGUOUS
	PBX_E_INVOKE_METHOD_INACCESSABLE
	PBX_E_INVOKE_REFARG_ERROR
	PBX_E_INVOKE_WRONG_NUM_ARGS
	PBX_E_MISMATCHED_DATA_TYPE
	PBX_E_NO_REGISTER_FUNCTION
	PBX_E_NO_SUCH_CLASS
	PBX_E_OUTOF_MEMORY
	PBX_E_READONLY_ARGS
	PBX_E_REGISTRATION_FAILED
	PBX_FAIL
	PBX_OK
	PBX_SUCCESS
	PB_CONNECTION_CACHE_C_SERVICE
	PB_CONNECTION_CACHE_SERVICE
	PB_DEBUG_SERVICE
	PB_LOGGING_SERVICE
	PB_SECURITY_SERVICE
	PB_TRANSACTION_SERVICE
	PB_TXNSERVER_EJB
	PB_TXNSERVER_JAGUAR
	PB_TXNSERVER_MTS
	PB_TXNSERVER_NONE
	PB_TXNSERVER_NORMAL_APP
	PB_TXNSERVER_SERVER
	pbgroup_application
	pbgroup_datawindow
	pbgroup_function
	pbgroup_menu
	pbgroup_proxy
	pbgroup_structure
	pbgroup_unknown
	pbgroup_userobject
	pbgroup_window
	pbvalue_any
	pbvalue_blob
	pbvalue_boolean
	pbvalue_byte
	pbvalue_char
	pbvalue_date
	pbvalue_datetime
	pbvalue_dec
	pbvalue_double
	pbvalue_dummy1
	pbvalue_dummy2
	pbvalue_dummy3
	pbvalue_dummy4
	pbvalue_int
	pbvalue_long
	pbvalue_longlong
	pbvalue_notype
	pbvalue_real
	pbvalue_string
	pbvalue_time
	pbvalue_uint
	pbvalue_ulong
	)) {
  next if (eval "my \$a = $constname; 1");
  if ($@ =~ /^Your vendor has not defined Powerbuilder::PBVM macro $constname/) {
    print "# pass: $@";
  } else {
    print "# fail: $@";
    $fail = 1;
  }

}

ok( $fail == 0 , 'Constants' );
#########################