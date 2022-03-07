module compiler

// TODO: proper ast nodes

fn parse(tokens []Token) {
	parse_define(tokens)
	// use
	// struct
	// interface
	// enum
	// function 
	// separate lists of private or public
}

fn parse_define(tokens []Token) {
	if tokens[0].token_type != .nal_define {
		panic('define not at top level')
		// TODO: proper compiler errors
	}
}