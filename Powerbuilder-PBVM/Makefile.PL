use 5.008008;
use ExtUtils::MakeMaker;
# See lib/ExtUtils/MakeMaker.pm for details of how to influence
# the contents of the Makefile that is written.
WriteMakefile(
    NAME              => 'Powerbuilder::PBVM',
    VERSION_FROM      => 'lib/Powerbuilder/PBVM.pm', # finds $VERSION
    PREREQ_PM         => {}, # e.g., Module::Name => 1.1
    ($] >= 5.005 ?     ## Add these new keywords supported since 5.005
      (ABSTRACT_FROM  => 'lib/Powerbuilder/PBVM.pm', # retrieve abstract from module
       AUTHOR         => 'Nicolas GEORGES <xlat@cpan.org>') : ()),
    LIBS              => [''], # e.g., '-lm'
    CC                => 'cl -TP',
    TYPEMAPS          => ['CPP.map', 'pbvm.map'],
    DEFINE            => '', # e.g., '-DHAVE_SOMETHING'
    INC               => '-I.', # e.g., '-I. -I/usr/include/other'
	# Un-comment this if you add C files to link with later:
    # OBJECT            => '$(O_FILES)', # link all the C files too
);

if  (eval {require ExtUtils::Constant; 1}) {
  # If you edit these definitions to change the constants used by this module,
  # you will need to use the generated const-c.inc and const-xs.inc
  # files to replace their "fallback" counterparts before distributing your
  # changes.
  my @names = (qw(
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
	));
  ExtUtils::Constant::WriteConstants(
                                     NAME         => 'Powerbuilder::PBVM',
                                     NAMES        => \@names,
                                     DEFAULT_TYPE => 'IV',
                                     C_FILE       => 'const-c.inc',
                                     XS_FILE      => 'const-xs.inc',
                                  );

}
else {
  use File::Copy;
  use File::Spec;
  foreach my $file ('const-c.inc', 'const-xs.inc') {
    my $fallback = File::Spec->catfile('fallback', $file);
    copy ($fallback, $file) or die "Can't copy $fallback to $file: $!";
  }
}

#prepare XS file from cpp
use InlineX::CPP2XS qw(cpp2xs);
use File::Slurp qw(slurp);
my $code = slurp("powerbuilder.cpp");
cpp2xs('Powerbuilder::PBVM', 'Powerbuilder', '.', {CODE => $code});

#~ 1) patch the const-c.inc file
#Filter 1)
open FH, '<', 'const-c.inc' or die $!;
my $file = join '', <FH>;
$file =~ s/#ifdef [^\s]+\n(.*\n.*)\n#else\n.*\n#endif/$1/gi;
close FH;
open FH, '>', 'const-c.inc' or die $!;
printf FH $file;
close FH;

#Filter 2) patch PBVM.xs
open FH, '<', 'PBVM.xs' or die $!;
my $file = join '', <FH>;
$file =~ s/(MODULE.*PACKAGE = Powerbuilder::PBVM\n+PROTOTYPES: DISABLE\n+)/$1\nINCLUDE: const-xs.inc\n/gi;
close FH;
open FH, '>', 'PBVM.xs' or die $!;
printf FH $file;
close FH;