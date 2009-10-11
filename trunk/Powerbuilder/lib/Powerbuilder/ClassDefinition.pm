#!/usr/bin/perl
package Powerbuilder::ClassDefinition;
#inherit from Powerbuilder::Variable( pbobject )
use base 'Powerbuilder::Variable'; 
use Powerbuilder::PBVM;
use Carp;

#TODO: use memoize module to cache classdefinition by name.

#~ sub new{
	#~ #allow to create a classdefinition from:
	#~ # - a classId => GetClassName, then ---v
	#~ # - a classname => FindClassDefinition

#~ }

sub DEBUG{
	#~ warn @_;
}

sub ancestor{ #readonly
	#return Powerbuilder::ClassDefinition
	my $self = shift;
	return $self->GetField('ancestor', 'Object');
}

sub category{ #readonly
	#return Powerbuilder::Variable( enum: type=TypeCategory, value= this->category )
	my $self = shift;
	return $self->GetField('category', pbvalue_int);
}

sub classdefinition{ #readonly
	#return Powerbuilder::ClassDefinition # = a clone of self ?
	my $self = shift;
	return $self->GetField('classdefinition', 'Object');
}

sub parentclass{ #readonly
	#return Powerbuilder::ClassDefinition
	my $self = shift;
	warn "<DEBUG> PARENTCLASS invoked ! </DEBUG>\n";
	return $self->GetField('parentclass', 'Object');
}

sub GetVariableCount{ #return upperbound( VariableList[] )
	my $self = shift;
	return $self->VM->GetArrayLength( $self->GetField('variablelist','Array')->pbvalue );
}

sub GetVariableName{ #given an Index id from 1 to FieldCount
	croak("TODO: GetVariableName not implemented yet! \n");
}

sub variablelist{
	my $self = shift;
	#~ return new Powerbuilder::Variable( @{$self->{_avars}} );
	return @{$self->{_avars}};
}

sub GetVariable{
	my ($self, $field) = @_;
	DEBUG "ClassDefinition::GetVariable($field)\t";
	
	if(defined($self->{_hvars})){
		#~ warn "initialized...\t";
		if($field =~ /^\d+$/){
			#by index
			my @vars = @{$self->{_avars}};
			return undef if scalar(@vars) < $field;
			return $vars[$field -1 ];
		}
		else{
			#by name
			my %vars = %{$self->{_hvars}};
			return undef unless exists $vars{$field};
			return $vars{$field};
		}
	}
	
	#~ warn "NOT initialized...\t";
	my %vars = ( );
	my @vars_array;
	foreach my $var( $self->GetField('variablelist','Array')->value ){
		my $name = $var->GetField('name', pbvalue_string);
		#~ warn ">>> Name pbvalue : " . $name->pbvalue . " for value `". $name->value ."`<<<\n";
		#~ warn "\n\t\t- adding $name";
		$vars{ $name } = $var;
		push @vars_array, $var;
	}
	$self->{_hvars} = \%vars;
	$self->{_avars} = \@vars_array;
	#~ warn " ... end...\n";
	return $self->GetVariable($field);
}

sub GetVariableDefinition{
	my ($self, $field) = @_;
	DEBUG "ClassDefinition::GetVariableDefinition($field)...\n";
	return $self->GetVariable( $field )->GetField('typeinfo','Object');
}

sub IsEnum{ #given the field name, return if it'is an enumération datatype.
	my ($self, $field) = @_;
	DEBUG "ClassDefinition::IsEnum($field)...\n";
	return $self->GetVariableDefinition($field)->GetField('category', pbvalue_int) == 1;
}

sub IsObject{
	my ($self, $field) = @_;
	DEBUG "ClassDefinition::IsObject($field)...\n";
	return $self->GetVariableDefinition($field)->GetField('category', pbvalue_int) == 2;
}

sub IsStruct{
	my ($self, $field) = @_;
	DEBUG "ClassDefinition::IsStruct($field)...\n";
	my $type = $self->GetVariableDefinition($field);
	return $type->GetField('category', pbvalue_int) == 2 
		&& $type->isstructure;
}

sub GenSIG{
	#return the prototype signature of the given arg'list.
	my $self = shift;
	my ($retType, @args);
	
	if(ref($_[0]) eq 'Powerbuilder::Variable' && $_[0]->ClassName eq 'scriptdefinition'){
		#assert it is have a argumentlist field !
		my $script = shift;
		@args = ( $script->argumentlist->value );
		$retType = $script->returntype;
	}
	else{
		($retType, @args) = @_;
	}

	my $proto = "";
	my %sig_prefix = ( 'byvalueargument' => '', 'byreferenceargument' => 'R', 
		'readonlyargument' => 'X', 'varlistargument' => 'V', );
	my %sig_part = ( 
		'array' => "[]", 'any' => "A", 'boolean' => "B", 'class' => "C", 'double' => "D",
		'byte' => "E", 'real' => "F", 'basictype' => "G", 'character' => "H", 'integer' => "I",
		'cursor' => "J", 'longlong' => "K", 'long' => "L", 'decimal' => "M", 'unsignedinteger' => "N",
		'uint' => "N", 'blob' => "O", 'dbproc' => "P", 'no type' => "Q", 'string' => "S",
		'time' => "T", 'unsignedlong' => "U", 'ulong' => "U", 'datetime' => "W", 'date' => "Y",
		'objhandle' => "Z", );

	foreach my $arg (@args){
		my $callconv = $arg->callingconvention->EnumItemName;
		$proto .= $sig_prefix{$callconv};
		my $typeinfo = $arg->typeinfo;
		my $datatypeofstr = $typeinfo->GetField('datatypeof')->value;
		if(exists $sig_part{$datatypeofstr}){
			$proto .= $sig_part{$datatypeofstr};
		}
		else{
			$proto .="C".$datatypeofstr.".";
		}
		
		my $cardinalityname = $arg->cardinality->cardinality->EnumItemName;
		if($cardinalityname ne 'scalartype'){
			if($cardinalityname eq 'boundedarray'){
				warn "unhandled sig for boundered array !\n";
				$proto .="[]";
			}
			else{
				$proto .="[]";
			}
		}
	}
	if(defined($retType)){
		$retType = $retType->GetField('datatypeof');
		$retType = (exists $sig_part{$retType}) ? $sig_part{$retType} : 'C'.$retType.'.';
	}
	else{
		$retType = 'Q';
	}
	$proto = $retType . $proto;
	
	return $proto;
}

1;