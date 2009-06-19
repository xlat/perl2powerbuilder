#!/usr/bin/perl

#THIS FILE IS A FAKE USED TO WRITE SOME CODE FROM A LUNIX STATION :)
package Powerbuilder::PBVM;

our $VERSION = 0.01;

sub new{
	my $class = shift;
	return bless {}, $class;
}

sub AUTOLOAD{
	print "\n".$AUTOLOAD."( ".join(',', @_)." )\n";
}
1;