#!/usr/bin/perl
package Powerbuilder::Value;

sub new{
	my $class = shift;
	my $self = bless {}, $class;
	$self->{session} = shift;
	return $self;
}

1;