module compiler

import error

[heap]
pub struct Parser {
	path string
pub mut:
	tokens []Token
	idx int
}

fn (mut p Parser) grab() Token {
	p.idx++
	return p.tokens[p.idx-1]
}

fn (mut p Parser) take(typ TokenType) Token {
	t := p.grab()
	if t.typ == typ {
		return t
	}
	error.compiler_fatal(p.path, t.line, t.col, 'expected `$typ` but got `$t.typ` instead!')
	parse_error++
	exit(1)
}

fn (mut p Parser) peek_next() Token {
	return p.tokens[p.idx]
}

// returns next token if 0 or i overflows the total len
fn (mut p Parser) peek(i int) Token {
	if p.idx + i > p.tokens.len || i == 0 {
		return p.peek_next()
	}
	return p.tokens[p.idx+i]
}

// check for eof. 
// checks if the offset will overflow the len
// returns `false` if all's good
fn (mut p Parser) eof_offset(i int) bool {
	return p.idx + i > p.tokens.len
}

// same as `eof_offset`, but defaults to 0.
[inline]
fn (mut p Parser) eof() bool {
	return p.eof_offset(0)
}

pub fn parse(path string, mut tokens []Token) []Node {

	mut nodes := []Node{}

	mut parser := Parser{
		path,
		tokens,
		0
	}

	for parser.peek_next().typ != .nal_eof {
		nodes << parse_variable(mut parser)
	}

	return nodes
}

pub fn parse_variable(mut parser Parser) Node {

	mut node := VariableNode{} 

	if parser.peek_next().typ == .identifier {
		node.typ = parser.take(.identifier).text
		node.ident = parser.take(.identifier).text

		parser.take(.nal_equals)

		if parser.peek_next().typ == .nal_string_lit {
			node.value = StringNode { parser.take(.nal_string_lit).text }
		}

		if parser.peek(1).typ in operators {
			node.value = parse_binary_statement(mut parser)
		}	
	}

	return node
}

pub fn parse_binary_statement(mut parser Parser) BinaryStatement {
	mut statement := BinaryStatement{}

	if parser.peek_next().typ == .nal_int_lit {
		statement.l = IntegerNode{ parser.take(.nal_int_lit).text.int() }
		statement.op = parser.grab().typ
		statement.r = IntegerNode{ parser.take(.nal_int_lit).text.int() }
	}

	if parser.peek_next().typ == .nal_float_lit {
		statement.l = FloatNode{ parser.take(.nal_float_lit).text.f64() }
		statement.op = parser.grab().typ
		statement.r = FloatNode{ parser.take(.nal_float_lit).text.f64() }
	}

	if parser.peek_next().typ in operators && parser.peek(1).typ == .nal_int_lit {
		return recurse_binary_statement(mut parser, mut statement)
	}

	return statement
}

fn recurse_binary_statement(mut parser Parser, mut statement BinaryStatement) BinaryStatement {
	mut stmt := BinaryStatement{}

	stmt.l = statement

	stmt.op = parser.grab().typ

	if parser.peek_next().typ == .nal_int_lit {
		tok := parser.take(.nal_int_lit)
		// check against dividing by 0
		if tok.text.int() == 0 && stmt.op == .nal_div {
			error.compiler_error(parser.path, tok.line, tok.col, 'dividing by 0 is not possible')
		} else {
			stmt.r = IntegerNode { tok.text.int() }
		}
	} else if parser.peek_next().typ == .nal_float_lit {
		panic('adding multiple floats together is not implemented yet')
	} 
	
	if parser.peek_next().typ in operators {
		println('we recursinn')
		return recurse_binary_statement(mut parser, mut stmt)
	}

	return stmt
}