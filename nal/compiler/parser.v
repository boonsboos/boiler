module compiler

import error

// TODO: proper ast nodes
struct Parser {
	path   string
mut:
	tokens []Token
	idx    int
}

fn (mut p Parser) take() Token {
	p.idx++
	return p.tokens[p.idx-1]
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

fn parse(mut tokens []Token, path string) {
	mut p := Parser{path, tokens, 0}

	mut node := FileNode{}

	node.define = parse_define(mut p)
	node.uses = parse_uses(mut p)
	// struct
	// interface
	// enum
	// function 
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

fn parse_functions(mut p Parser) {
	if parser.peek_one().token_type == .nal_function {
		parser.take_type(.nal_function)

		if parser.peek_one() == .nal_open_paren {
			// TODO: definition on
		}
		ident := parser.take_type(.nal_identifier)
		parser.take_type(.nal_open_paren)
		// TODO: params
		parser.take_type(.nal_close_paren)
		
		if parser.peek_one().type == .nal_identifier {
			// TODO: return type
		}
		parser.take_type(.nal_open_curly)
		// TODO: statements
	}
}