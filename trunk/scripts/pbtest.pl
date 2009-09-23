#!/usr/bin/perl -I../Powerbuilder/lib
use Powerbuilder;

my $pb = new Powerbuilder( '../Powerbuilder/t/scriptingpb.pbt' );

my $nvo = $pb->create( "nv_proto" );
print "is_msg = ".$nvo->is_msg."\n";
print "is_msg is null = " . $nvo->is_msg->isnull ."\n";
print "ii_v1 = ".$nvo->ii_v1."\n";
print "ii_v1 isnull = ".$nvo->ii_v1->isnull."\n";
my $ii_v1 = $nvo->ii_v1;
print "ii_v1 = ii_v1 + 10 => " . (  $ii_v1 = $ii_v1 + 10 ) . "\n";
#But at this time, modifier in Powerbuilder::Value object isn't reflected to PBVM...
#so the following will give the initial value:
print "ii_v1 = ".$nvo->ii_v1."\n";
#This is because I don't keep a real reference to the pb variable in the case of field property !
#-> It should have :
# - property $Powerbilder::Value->{reftype} = global|shared|field|anonymous|property
# - property $Powerbuilder::Value->{refparams} = ( groupid, classid, name, pbval )
# May I create a Powerbuilder::Reference object ? with constructors for each type ?


$pb->close;


#What is ugly with my Powerbuilder::Value::new constructor is :
#1) the first parameter : $session => could be common to all Powerbuilder:: descendent ?
#									-> but only one session at a time could be used.
#2) ...