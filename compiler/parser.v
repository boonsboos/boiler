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
	println(t.typ)
	if t.typ == typ {
		return t
	}
	error.compiler_fatal(p.path, t.line, t.col, 'expected `$typ` but got `$t.typ` instead!')
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

		// if parser.peek_next().typ == .nal_string_lit {
		// 	node.value = StringNode { parser.take(.nal_string_lit).text }
		// }

		if parser.peek_next().typ == .nal_int_lit {
			node.value = Literal(IntegerNode{ parser.take(.nal_int_lit).text.int() })
		}

		if parser.peek_next().typ in operators {
			pass := node.value
			mut new := Binary{}
			new.l = pass
			new.op = parser.grab()
			new.r = get_literal(mut parser)
			node.value = new
		}

	}

	return node
}

fn get_literal(mut parser Parser) Literal {

	tok := parser.take()

	match tok.typ {
		.nal_int_lit {
			return Literal(IntegerNode{ tok.text.int() })
		}
		.nal_float_lit {
			return Literal(FloatNode { tok.text.f64() })
		}
		.nal_string_lit {
			return Literal(StringNode { tok.text })
		}
		.nal_false {
			return Literal(BoolNode { false })
		}
		.nal_true {
			return Literal(BoolNode { true })
		}
		else {
			error.compiler_fatal(
				parser.path, tok.line, tok.col,
				"not a literal!")
		}
	}

	return 
}