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
	// struct
	// interface
	// enum
	// function 
	for !p.eof() {
		match p.peek_one().token_type {
			.nal_function {
				node.functions << parse_functions(mut p)
			}
			.nal_struct {
				node.structs << parse_structs(mut p)
			}
			.nal_interface {

			}
			.nal_enum {
				node.enums << parse_enums(mut p)
			}
			else { break }
		}
		
	}
	// separate lists of private or public
	println(node)
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
			parser.take_type(.nal_identifier) // variable
			parser.take_type(.nal_close_paren)
		}
		node.name = parser.take_type(.nal_identifier).text
		parser.take_type(.nal_open_paren)
		if parser.peek_one().token_type == .nal_identifier {
			for parser.peek(2).token_type == .nal_comma {
				node.params << Variable {
					parser.take_type(.nal_identifier).text // type
					parser.take_type(.nal_identifier).text // variable
				}
				parser.take_type(.nal_comma)
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
			// TODO: statements
			parser.take()
		}

	}
	return node
}

fn parse_enums(mut parser Parser) EnumNode {
	mut node := EnumNode{}

	if parser.peek_one().token_type == .nal_enum {

		mut re := regex.new()
		re.compile_opt('^[A-Z]$') or { panic('bad regex pattern') }

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
		node.name = parser.take_type(.nal_identifier).text

		parser.take_type(.nal_open_curly)

		for parser.peek_one().token_type != .nal_close_curly {
			node.members << Variable{
				parser.take_type(.nal_identifier).text // type
				parser.take_type(.nal_identifier).text // name
			}
		}

		parser.take_type(.nal_close_curly)

	}
	return node
}

fn parse_interfaces(mut parser Parser) {
	if parser.peek_one().token_type == .nal_interface {
		parser.take_type(.nal_interface)

		
	}
}