module compiler

type Statement = DeclarationStatement | FunctionCallStatement | MathStatement | StructInitStatement

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

fn parse_function_call(mut parser Parser) FunctionCallStatement {
	mut call := FunctionCallStatement{}

	call.name = parser.take_type(.nal_identifier).text

	parser.take_type(.nal_open_paren)

	for parser.peek_one().token_type != .nal_close_paren {
		call.params << parser.take().text
		// here we can be sure that it's an identifier
		if parser.peek_one().token_type == .nal_dot {
			// array jank
			call.params << call.params.pop() + 
			parser.take_type(.nal_dot).text + 
			parser.take_type(.nal_identifier).text
		}
	}	

	parser.take_type(.nal_close_paren)
	
	return call
}

// StructName{} | default init
// StructName{member, member} | init
pub struct StructInitStatement {
pub mut:
	name string
	members []string
}

fn parse_struct_init(mut parser Parser) DeclarationStatement {
	var := Variable {
		parser.take_type(.nal_identifier).text // type
		parser.take_type(.nal_identifier).text // name
	}

	parser.take_type(.nal_equals)

	mut struct_init := StructInitStatement{}
	struct_init.name = parser.take_type(.nal_identifier).text

	parser.take_type(.nal_open_curly)

	for parser.peek_one().token_type != .nal_close_curly {
		struct_init.members << parser.take_type(.nal_identifier).text // member
		if parser.peek_one().token_type == .nal_comma {
			parser.take_type(.nal_comma)
		}
	}

	parser.take_type(.nal_close_curly)

	return DeclarationStatement { var, struct_init }

}

pub struct MathStatement {
pub mut:
	var Variable
	a Value
	op TokenType
	b Value
}