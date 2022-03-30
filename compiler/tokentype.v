module compiler

pub enum TokenType {
	// numbers
	nal_int_lit
	nal_float_lit
	nal_string_lit
	nal_nal	// null
	// boolean values
	nal_true
	nal_false
	//var	// automatically converts type might add this later
	// logic
	nal_if
	nal_else
	// loops
	nal_for
	nal_while
	// data structures
	nal_function
	nal_struct
	nal_interface
	nal_enum
	// access modifiers
	nal_public
	// module stuff
	nal_use
	nal_define
	// (con|de)struction stuff
	// nal_new
	// nal_destroy
	// anything that's a type, module function or variable name
	identifier
	// eof
	nal_eof
	// characters important for blocks
	nal_open_paren
	nal_close_paren
	nal_open_curly
	nal_close_curly
	nal_dot
	nal_comma
	nal_colon
	whitespace
	comment // starts with @, skips the entire line

	nal_equals // =
	// TODO BINARY OPS
	// MATH OPS
	nal_plus // +
	nal_minus// -
	nal_mult // *
	nal_div  // /
	nal_mod  // %
	// BOOLEAN OPS
	nal_bool_and // &&
	nal_bool_or  // ||
	nal_bool_not // !
	nal_cmpeq // ==
	nal_gt // >
	nal_gteq // >=
	nal_lt // <
	nal_lteq // <=
}

pub const (
	operators = [
	.nal_plus, .nal_minus, .nal_mult, .nal_div, .nal_mod,
	.nal_bool_and, .nal_bool_not, .nal_bool_or, .nal_cmpeq,
	.nal_gt, .nal_gteq, .nal_lt, .nal_lteq
	]
	// slight bug
	literals = [TokenType.identifier, .nal_string_lit, .nal_int_lit, .nal_float_lit]
)