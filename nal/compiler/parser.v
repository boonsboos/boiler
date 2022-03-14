module compiler

import regex

import error

struct Parser {
	path   string
mut:
	tokens []Token
	idx    int
}

fn (mut p Parser) take() Token {
 	tok := p.tokens[p.idx]
	p.idx++
	return tok
}

fn (mut p Parser) take_type(t TokenType) Token {
	tok := p.take()
	if tok.token_type == t {
		return tok
	}
	error.compiler_error(p.path, tok.line, tok.col, 'expected `$t` but got `$tok.token_type`')
	exit(1)
}

fn (mut p Parser) peek_one() Token {
	return p.tokens[p.idx]
}

fn (mut p Parser) peek(i int) Token {
	if p.idx + i > p.tokens.len {
		return p.peek_one()
	}
	return p.tokens[p.idx+i]
}

fn (mut p Parser) eof() bool {
	return p.idx >= p.tokens.len
}

// MAIN PARSE FUNCTION
fn parse(mut tokens []Token, path string) {
	mut p := Parser{path, tokens, 0}

	mut node := FileNode{}

	node.define = parse_define(mut p)
	node.uses = parse_uses(mut p)

	// parse data structures and functions 
	for !p.eof() {
		match p.peek_one().token_type {
			.nal_function {
				node.functions << parse_functions(mut p)
			}
			.nal_struct {
				node.structs << parse_structs(mut p)
			}
			.nal_interface {
				node.interfaces << parse_interfaces(mut p)
			}
			.nal_enum {
				node.enums << parse_enums(mut p)
			}
			else { break }
		}
		
	}
	// separate lists of private or public

	// this variable is defined in ../error/error.v
	if parse_error > 0 {
		error.compiler_message('exiting due to errors', .fatal)
		exit(1)
	}

	println(node)

	// return AST to codegen
}

fn parse_define(mut parser Parser) DefineNode {
	mut node := DefineNode{}
	parser.take_type(.nal_define)
	node.name = parser.take_type(.nal_identifier).text
	return node
}

fn parse_uses(mut parser Parser) []UseNode {
	mut uses := []UseNode{}
	for parser.peek_one().token_type == .nal_use {
		mut node := UseNode{}

		parser.take_type(.nal_use) // verify the data isn't changed
		node.mod = parser.take_type(.nal_identifier).text

		if parser.peek_one().token_type == .nal_dot {
			parser.take_type(.nal_dot)
			node.imported = parser.take_type(.nal_identifier).text
		}
		uses << node
	}
	return uses
}

fn parse_functions(mut parser Parser) FunctionNode {

	mut node := FunctionNode{}

	if parser.peek_one().token_type == .nal_function {
		parser.take_type(.nal_function)

		if parser.peek_one().token_type == .nal_open_paren {
			parser.take_type(.nal_open_paren)
			node.def_type = parser.take_type(.nal_identifier).text // type
			parser.take_type(.nal_close_paren)
		}

		node.name = parser.take_type(.nal_identifier).text // function name

		parser.take_type(.nal_open_paren)

		if parser.peek_one().token_type == .nal_identifier {

			node.params << Variable {
				parser.take_type(.nal_identifier).text // type
				parser.take_type(.nal_identifier).text // variable
			}

			for parser.peek(2).token_type == .nal_comma {
				parser.take_type(.nal_comma)
				node.params << Variable {
					parser.take_type(.nal_identifier).text // type
					parser.take_type(.nal_identifier).text // variable
				}
				
			}
		}
		parser.take_type(.nal_close_paren)
		
		// return type
		if parser.peek_one().token_type == .nal_identifier {
			node.ret_type = parser.take_type(.nal_identifier).text
		} else {
			error.compiler_crit_error(parser.path, parser.peek_one().line, parser.peek_one().col,
			'functions have to have a return type. if not returning anything, add `void` before the curly brace')
		}
		parser.take_type(.nal_open_curly)
		
		for parser.peek_one().token_type != .nal_close_curly {
			node.statement << parse_statements(mut parser)
		}

		parser.take_type(.nal_close_curly)

	}
	return node
}

fn parse_enums(mut parser Parser) EnumNode {
	mut node := EnumNode{}

	if parser.peek_one().token_type == .nal_enum {

		mut re := regex.new()
		re.compile_opt('^[A-Z_]$') or { panic('bad regex pattern in parse_enums') }

		parser.take_type(.nal_enum)

		node.name = parser.take_type(.nal_identifier).text

		parser.take_type(.nal_open_curly)

		for parser.peek_one().token_type != .nal_close_curly {
			tok := parser.take_type(.nal_identifier) // extra variable for erroring purposes
			value := tok.text
			// returns false if matches?
			if re.matches_string(value) {
				error.compiler_error(parser.path, tok.line, tok.col, 'enum value `$value` must be uppercase!')
			} 
			node.values << value
		}
	}
	return node
}

fn parse_structs(mut parser Parser) StructNode {

	mut node := StructNode{}

	if parser.peek_one().token_type == .nal_struct {
		
		parser.take_type(.nal_struct)

		if parser.peek_one().token_type == .nal_open_curly {
			error.compiler_error(parser.path, parser.tokens[parser.idx+1].line, parser.tokens[parser.idx+1].col,
			'struct needs a name')
		}

		node.name = parser.take_type(.nal_identifier).text

		// TODO: make room for dedicated interface implementation
		// use this syntax!!
		// struct StructName : InterfaceName { }
		parser.take_type(.nal_open_curly)

		if parser.peek_one().token_type == .nal_close_curly {
			error.compiler_error(parser.path, parser.tokens[parser.idx+1].line, parser.tokens[parser.idx+1].col,
			'struct cannot be empty!')
		}

		for parser.peek_one().token_type != .nal_close_curly {
			node.members << Variable{
				parser.take_type(.nal_identifier).text // name
				parser.take_type(.nal_identifier).text // type
			}
		}

		parser.take_type(.nal_close_curly)

	}
	return node
}

fn parse_interfaces(mut parser Parser) InterfaceNode {

	mut node := InterfaceNode{}

	if parser.peek_one().token_type == .nal_interface {
		parser.take_type(.nal_interface)

		if parser.peek_one().token_type == .nal_open_curly {
			error.compiler_error(parser.path, parser.tokens[parser.idx+1].line, parser.tokens[parser.idx+1].col,
			'interface needs a name')
		}

		node.name = parser.take_type(.nal_identifier).text

		parser.take_type(.nal_open_curly)

		for parser.peek_one().token_type != .nal_close_curly {
			parser.take()
		}

		parser.take_type(.nal_close_curly)
	}

	return node
}

// it's easier to return an array here
fn parse_statements(mut parser Parser) []Statement {

	mut statements := []Statement{}

	// functionName()
	if parser.peek_one().token_type == .nal_identifier && 
	parser.peek(1).token_type == .nal_open_paren {
		statements << parse_function_call(mut parser)	
	}

	// Type Var = Struct{}
	if parser.peek(2).token_type == .nal_equals && 
	parser.peek(4).token_type == .nal_open_curly {
		statements << parse_struct_init(mut parser)
	}

	// Type Var = functionName()

	return statements

}