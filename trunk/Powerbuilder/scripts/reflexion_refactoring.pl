#!/usr/bin/perl

BEGIN{
	chdir '../t' ;
}

use lib '../lib';
#~ use lib '../blib/arch';
use Data::Dumper;

$|=1;

use Powerbuilder;
use Powerbuilder::PBVM;
use Powerbuilder::Variable;

my $pb = new Powerbuilder( 'scriptingpb.pbt' );

my $classdef = $pb->GetClassDefinition( "classdefinition" );
print "ClassID=".$classdef->classid."\n";
#~ print "Field count=".$classdef->FieldCount."\n";
#~ #for(1..$classdef->FieldCount){
#~ #	print "\t" . $classdef->GetVariable($_)->name;
#~ #	print "\n";
#~ #}
#~ #print "-" x 40 . "\n";
#~ print "Ancestor's name= ". $classdef->ancestor->name ."\n";
#~ print "name = " . $classdef->name . "\n";
#~ print "category = " . $classdef->category . "\n";
#~ print "datatypeof = " . $classdef->datatypeof . "\n";
#~ print "isautoinstantiate = " . $classdef->isautoinstantiate . "\n";
#~ #print "parentclass's name = " . $classdef->parentclass->name . "\n"; #crashing PBNI !
#~ print "IsEnum(category) : " . $classdef->IsEnum('category') . "\n";
#~ print "IsObject(category) : " . $classdef->IsObject('category') . "\n";
#~ print "IsStruct(category) : " . $classdef->IsStruct('category') . "\n";
#~ print "IsObject(parentclass) : " . $classdef->IsObject('parentclass') . "\n";
#~ print "IsStruct(parentclass) : " . $classdef->IsStruct('parentclass') . "\n";
#~ print "IsObject(ancestor) : " . $classdef->IsObject('ancestor') . "\n";
#~ print "IsStruct(ancestor) : " . $classdef->IsStruct('ancestor') . "\n";

#~ print "variablelist= {\n";
#~ foreach my $var( $classdef->variablelist ){
	#~ print "\t* ";
	#~ print	$var->name;
	#~ my $vartype = $var->typeinfo;
	#~ print " (" . $vartype->name . " = ";
	#~ print $vartype->GetField('datatypeof') . " : ";
	#~ print $vartype->category . " )";
	#~ # print " (" . $var->cardinality->Cardinality . ")";	#TODO: handle Error naming...
	#~ print " (" . $var->cardinality->cardinality . ")";	#object => 16626
	#~ print " (" . $var->typeinfo->name . ")";	#object => 16582
	#~ print " (" . $var->callingconvention . ")";	#enum => 16617
	#~ print " (" . $var->kind . ")";	#enum => 16615
	#~ print " (" . $var->readaccess . ")";	#enum => 16616
	#~ print " (" . $var->writeaccess . ")";	#enum => 16616
	#~ print "\n";
#~ }
#~ print "}\n";
#~ print "-" x 40 . "\n";

foreach my $script ( $classdef->scriptlist->value ){				#autoload can look first for field, then for scripts; here it is a field returned as a list of Powerbuilder::Variable if wantarray return true in the FieldGetter.
	print $script->name;
	my $rt = "(none)";
	my $returntype = $script->returntype;
	if(defined($returntype)){
		$rt = $returntype->name;
	}
	print "(". $script->def->GenSIG($script) .") return $rt\n";
}


END{
	chdir '../scripts';
}