package Powerbuilder;
use Powerbuilder::PBVM;
use 5.008008;
use strict;
use warnings;

require Exporter;

our @ISA = qw(Exporter);

# Items to export into callers namespace by default. Note: do not export
# names by default without a very good reason. Use EXPORT_OK instead.
# Do not simply export all your public functions/methods/constants.

# This allows declaration	use Powerbuilder ':all';
# If you do not need this, moving things directly into @EXPORT or @EXPORT_OK
# will save memory.
our %EXPORT_TAGS = ( 'all' => [ qw(
	
) ] );

our @EXPORT_OK = ( @{ $EXPORT_TAGS{'all'} } );

our @EXPORT = qw(
	
);

our $VERSION = '0.01';


# Preloaded methods go here.
sub create{	#create an object
}

sub destroy{ #destroy an object
}

sub open{	#open session
}

sub run{	#run application | same as open but run application.
}

sub close{	#close session
}

sub find_macting_prototype{	# ( $name, $type = FUNCT|EVENT, \@args (of_type Powerbuilder::Value...) [ ,$class]
}

sub get_global{ #
}

sub set_global{ #
}

sub get_shared{ #
}

sub set_shared{ #
}

#~ #Some reflexion methods.
sub get_globals{ #
}

sub get_shareds{ #
}

sub get_systemfunctions{ #retrieve functions... ? Have a sens ?
}
sub get_global_functions{ #
}
1;
__END__
# Below is stub documentation for your module. You'd better edit it!

=head1 NAME

Powerbuilder - Perl extension for blah blah blah

=head1 SYNOPSIS

  use Powerbuilder;
  blah blah blah

=head1 DESCRIPTION

Stub documentation for Powerbuilder, created by h2xs. It looks like the
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

Nicolas GEORGES, E<lt>xlat@cpan.orgE<gt>

=head1 COPYRIGHT AND LICENSE

Copyright (C) 2009 by Nicolas GEORGES.

This library is free software; you can redistribute it and/or modify
it under the same terms as Perl itself, either Perl version 5.8.8 or,
at your option, any later version of Perl 5 you may have available.


=cut
