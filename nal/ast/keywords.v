module ast

pub enum Keywords {
	nal_byte	// aliases for the above types
	nal_short
	nal_int
	nal_long
	nal_ubyte
	nal_ushort
	nal_uint
	nal_ulong
	nal_float
	nal_double
	nal_string
	nal_bool
	nal_nal	// null
	nal_void
	nal_true
	nal_false
	//var	// automatically converts type might add this later
	nal_if
	nal_else
	nal_for
	nal_while
	nal_struct
	nal_interface
	nal_enum
	nal_constructor
	nal_this
	nal_public
	nal_private
	nal_static
	nal_final
	nal_use
	nal_define
	nal_new
	nal_destroy
}

pub enum Lexemes {
	nal_open_paren		// function parameters
	nal_close_paren		// close function parameters
	nal_open_curly		// block open
	nal_close_curly		// block close
	nal_assignment		// int variablename = 1;
	nal_end_line		// ;
	nal_type_decl		// takes a Keyword, part of type
}

pub enum Datatypes {
	nal_number
	nal_boolean
	nal_string
	nal_structure
	nal_enum
	nal_loop
	nal_conditional
	nal_function_call
	nal_function_body
}

pub enum AccessModifier {
	public
	@static 
	private 
	final
}