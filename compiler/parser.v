module compiler

import error

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
	return p.idx + i >= p.tokens.len
}

// same as `eof_offset`, but defaults to 0.
[inline]
fn (mut p Parser) eof() bool {
	return p.eof_offset(0)
}

pub fn parse(path string, mut tokens []Token) {

	mut nodes := []Node{}

	mut parser := Parser{
		path,
		tokens,
		0
	}

	parse_variable(mut parser)
}

pub fn parse_variable(mut parser Parser) {

}