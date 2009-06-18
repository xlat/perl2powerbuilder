package Powerbuilder::PBVM;

use 5.008008;
use strict;
use warnings;
use Carp;

require Exporter;
use AutoLoader;

our @ISA = qw(Exporter);

# Items to export into callers namespace by default. Note: do not export
# names by default without a very good reason. Use EXPORT_OK instead.
# Do not simply export all your public functions/methods/constants.

# This allows declaration	use Powerbuilder::PBVM ':all';
# If you do not need this, moving things directly into @EXPORT or @EXPORT_OK
# will save memory.
our %EXPORT_TAGS = ( 'all' => [ qw(
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
)
 ] );

our @EXPORT_OK = ( @{ $EXPORT_TAGS{'all'} } );

our @EXPORT = qw(
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
);

our $VERSION = '0.01';

sub AUTOLOAD {
    # This AUTOLOAD is used to 'autoload' constants from the constant()
    # XS function.

    my $constname;
    our $AUTOLOAD;
	
    ($constname = $AUTOLOAD) =~ s/.*:://;
	
    croak "&Powerbuilder::PBVM::constant not defined" if $constname eq 'constant';
    my ($error, $val) = constant($constname);
    if ($error) { croak $error; }
    {
	no strict 'refs';
	# Fixed between 5.005_53 and 5.005_61
#XXX	if ($] >= 5.00561) {
#XXX	    *$AUTOLOAD = sub () { $val };
#XXX	}
#XXX	else {
	    *$AUTOLOAD = sub { $val };
#XXX	}
    }
    goto &$AUTOLOAD;
}

require XSLoader;
XSLoader::load('Powerbuilder::PBVM', $VERSION);

# Preloaded methods go here.

#given a project return the application object name followed by
#the library list joined with ;
#TODO: you can pass an additonnal parameter which would be a 
#		relative path to add at the beginning of each libs.
sub project{
	my $p = shift;
	$p = shift if ref($p) eq __PACKAGE__;
	open(my $PROJECT, '<', $p) or croak("Could not open project file $p ! \n");
	my $app;
	my $libs;
	my $nblibs;
	while(<$PROJECT>){
		if(/appname\s*"([^"]+)"/){
			$app = $1;
		}
		if(/LibList\s*"([^"]+)"/){
			$libs = $1;
		}
	}
	close $PROJECT;
	my @libs = split /;/,$libs;
	$nblibs = scalar @libs;
	return ($app, $libs, $nblibs);
}

# Autoload methods go after =cut, and are processed by the autosplit program.

1;
__END__
# Below is stub documentation for your module. You'd better edit it!

=head1 NAME

Powerbuilder::PBVM - Perl extension for blah blah blah

=head1 SYNOPSIS

  use Powerbuilder::PBVM;
  blah blah blah

=head1 DESCRIPTION

Stub documentation for Powerbuilder::PBVM, created by h2xs. It looks like the
author of the extension was negligent enough to leave the stub
unedited.

Blah blah blah.

=head2 EXPORT

None by default.



=head1 SEE ALSO

Mention other useful documentation such as the documentation of
related modules or operating system documentation (such as man pages
in UNIX), or any relevant external documentation such as RFCs or
standards.

If you have a mailing list set up for your module, mention it here.

If you have a web site set up for your module, mention it here.

=head1 AUTHOR

A. U. Thor, E<lt>a.u.thor@a.galaxy.far.far.awayE<gt>

=head1 COPYRIGHT AND LICENSE

Copyright (C) 2009 by A. U. Thor

This library is free software; you can redistribute it and/or modify
it under the same terms as Perl itself, either Perl version 5.8.8 or,
at your option, any later version of Perl 5 you may have available.


=cut
