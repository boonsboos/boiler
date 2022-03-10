module compiler

type Statement = DeclarationStatement | FunctionCallStatement

// Type VariableName = FunctionCallStatement
// Type VariableName = StructInitStatement
// Type VariableNmae = Value
pub struct DeclarationStatement {
pub mut:
	var Variable
	val Value
}

type Value = FunctionCallStatement | StructInitStatement

// function() | no params
// function(param, param) | params
pub struct FunctionCallStatement {
pub mut:
	name string
	params []Variable
}

// StructName{} | default init
// StructName{member, member} | init
pub struct StructInitStatement {
pub mut:
	name string
	members []Variable
}