module compiler

pub enum TokenType {
	// numbers
	literal
	str_literal
	// boolean values
	var // for module or global constants (can be mut)
	// logic
	bif
	belse
	// loops
	loop
	// data structures
	bfn
	btype
	// module stuff
	use
	pack

	identifier
	// eof
	eof
	// characters important for blocks
	pipe
	dollar
	open_paren
	close_paren
	open_curly
	close_curly
	dot
	comma
	colon
	whitespace
	comment // starts with @, skips the entire line
	equals // =
	assign // :=
	// TODO BINARY OPS
	// MATH OPS
	plus // +
	minus // -
	mult // *
	div // /
	mod // %
	// BOOLEAN OPS
	bool_and // &&
	bool_or // ||
	bool_not // !
	cmpeq // ==
	gt // >
	gteq // >=
	lt // <
	lteq // <=
}

pub const (
	operators = [
		TokenType.plus,
		.minus,
		.mult,
		.div,
		.mod,
		.bool_and,
		.bool_not,
		.bool_or,
		.cmpeq,
		.gt,
		.gteq,
		.lt,
		.lteq,
	]
	// slight bug
	literals  = [TokenType.identifier, .str_literal, .literal]
)
