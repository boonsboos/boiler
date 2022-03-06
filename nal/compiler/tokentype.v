module compiler

pub enum TokenType {
	// numbers
	nal_number
	// nal_byte	// aliases for the above types
	// nal_short
	// nal_int
	// nal_long
	// nal_ubyte
	// nal_ushort
	// nal_uint
	// nal_ulong
	// nal_float
	// nal_double
	// other types
	nal_string
	nal_string_lit
	nal_bool
	nal_nal	// null
	// return type
	nal_void
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
	nal_struct
	nal_interface
	nal_enum
	// access modifiers
	nal_public
	// module stuff
	nal_use
	nal_define
	// (con|de)struction stuff
	nal_new
	nal_destroy

	nal_identifier

	nal_eof

	nal_open_paren
	nal_close_paren

	nal_open_curly
	nal_close_curly

	nal_dot
	
	whitespace
	comment
}

