#!/usr/bin/perl -I../Powerbuilder/lib
use Powerbuilder;

my $pb = new Powerbuilder( '../t/scriptingpb.pbt' );

my $nvo = $pb->create( "unvo_proto" );


$pb->close;