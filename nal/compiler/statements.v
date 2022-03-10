module compiler

type Statement = DeclarationStatement | FunctionCallStatement | MathStatement

// Type VariableName = FunctionCallStatement
// Type VariableName = StructInitStatement
// Type VariableNmae = Value
pub struct DeclarationStatement {
pub mut:
	var Variable
	val Value
}

type Value = FunctionCallStatement | StructInitStatement | int

// function() | no params
// function(param, param) | params
pub struct FunctionCallStatement {
pub mut:
	name string
	params []string
}

// StructName{} | default init
// StructName{member, member} | init
pub struct StructInitStatement {
pub mut:
	name string
	members []string
}

pub struct MathStatement {
pub mut:
	var Variable
	a Value
	op TokenType
	b Value
}