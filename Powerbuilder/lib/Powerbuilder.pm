package Powerbuilder;
use Powerbuilder::PBVM;
use Powerbuilder::Value;
use Powerbuilder::Object;
use 5.008008;
#~ use strict;
use warnings;
use Carp;
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

our $VERSION = '0.02';

our $VM = undef;
our $SESSION = undef;	#For now, Powerbuilder package act as a singleton (not really in fact)...

sub VM{ return $_[0]->{VM}; }
# Preloaded methods go here.
sub new{
	my $class = shift;
	my $self = bless {}, $class;
	$self->{VM} = new Powerbuilder::PBVM;
	$self->open( @_ ) if @_;
	$Powerbuilder::SESSION = $self;
	return $self;
}

sub open{	#open a session
	my $self = shift;
	my $project = shift;	#we may check if ARG is a HASH ref...
	my @args;
	my $dir = undef;
	#Extract path if any
	if($project=~/^(.*[\/\\])([^\/\\]+)$/){
		use Cwd;
		$dir = cwd;
		chdir($1);
		@args = $self->{VM}->project( $2 );
	}
	else{
		@args = $self->{VM}->project( $project );
	}
	my $r = $self->{VM}->CreateSession( @args );
	#~ chdir($dir) if $dir;
	
	$Powerbuilder::VM = $self->VM;	#Only one session at a time...
	
	return $r;
}

sub run{	#run application | same as open but run application.
	#~ $Powerbuilder::VM = $self->VM;
}

sub close{	#close session
	my $self = shift;
	$self->{VM}->ReleaseSession;
}
#-+-+-+-+-+-+-+-+-+-+-+-+-+-

sub create{	#create an object
	my $self = shift;
	my $classname = shift;	#must be a classname
	my $groupid;
	
	foreach my $group ( pbgroup_application , pbgroup_datawindow , pbgroup_function , 
		pbgroup_menu , pbgroup_proxy , pbgroup_structure , 
		pbgroup_userobject , pbgroup_window , pbgroup_unknown ){
		$groupid = $self->{VM}->FindGroup( $classname,  $group) and last;
	}
	croak "no group for `$classname`" unless $groupid;
	
	my $classid = $self->{VM}->FindClass( $groupid, $classname ) or croak "no class for `$classname`";
	my $pbobj = $self->{VM}->NewObject( $classid ) or croak "could not create object for `$classname`";
	return new Powerbuilder::Object( $self, 0, $pbobj );
}

sub destroy{ #destroy an object
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
