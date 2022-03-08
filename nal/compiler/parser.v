module compiler

// TODO: proper ast nodes

fn parse(mut tokens []Token) {
	parse_define(mut tokens)
	// use
	// struct
	// interface
	// enum
	// function 
	// separate lists of private or public
}

fn parse_define(mut tokens []Token) {
	if tokens[0].token_type != .nal_define {
		panic('define not at top level')
		// TODO: proper compiler errors
	}
}