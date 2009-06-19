#!/usr/bin/perl
package Powerbuilder::Object;
use base qw( Powerbuilder::Value );
use Carp;

sub new{
	my ($class, %arg_ref) = @_;
	my $self = $class->SUPER::new( %arg_ref );
	#Here place special code...
	return $self;
}

1;