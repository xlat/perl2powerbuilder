use Powerbuilder qw( systemfunctions );
#Here FindClassDefinition( ) is autoloaded by Powerbuilder::AUTOLOAD
#but must be exported manually using a special tag in 'use'  pragma

#~ sub GetSIG{
	
#~ }

my $classdef = FindClassDefinition( "systemfunctions" );			#return a Powerbuilder::Object package.
foreach my $script ( $classdef->scriptlist ){				#autoload can look first for field, then for scripts; here it is a field returned as a list of Powerbuilder::Variable if wantarray return true in the FieldGetter.
	print $script->name . "(...)\n";#. "(" . GetSIG( $script->argumentlist ) . ")\n";	#here GetSIG is able to work with a Powerbuilder::Variable of type SimpleArray or with a list of Powerbuilder::Variable
}
