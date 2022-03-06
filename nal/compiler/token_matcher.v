module compiler

import regex

fn match_token(file string, path string, line int, col int, current string) ?Token {

	match true {
		current.starts_with(" ") {
			return Token{" ", line, col, .whitespace}
		}
		current.starts_with("\t") {
			return Token{" ", line, col, .whitespace}
		}
		current.starts_with("\v") {
			return Token{" ", line, col, .whitespace}
		}
		current.starts_with("\f") {
			return Token{" ", line, col, .whitespace}
		}
		current.starts_with("@") {
			return Token{'@'+current.find_between("@", "\n"), line, col, .comment} // we ignore comments
		}
		current.starts_with(".") {
			return Token{".", line, col, .nal_dot}
		}
		current.starts_with("{") {
			return Token{"{", line, col, .nal_open_curly}
		}
		current.starts_with("}") {
			return Token{"}", line, col, .nal_close_curly}
		}
		current.starts_with("(") {
			return Token{"(", line, col, .nal_open_paren}
		}
		current.starts_with(")") {
			return Token{")", line, col, .nal_close_paren}
		}
		current.starts_with("void") {
			return Token{"void", line, col, .nal_void}
		}
		current.starts_with("define") {
			return Token{"define", line, col, .nal_define}
		}
		current.starts_with("use") {
			return Token{"use", line, col, .nal_use}
		}
		current.starts_with("pub") {
			return Token{"pub", line, col, .nal_public}
		}
		
		else {
			// TODO: do regex stuff here
			token := regex_token(file, path, line, col, current) or { return Token{current, line, col, .nal_eof} }
			return token
		}
	}

	return Token{current, line, col, .nal_eof}
}

fn regex_token(file string, path string, line int, col int, current string) ?Token {
	mut re := regex.new()
	if current.starts_with('"') {
		re.compile_opt('^"{1}.+"{1}$') or { panic(err) }
		matches := re.find_all_str(current)
		if matches.len < 1 {
			panic('$file:$line:$col [ERROR] | failed to tokenise string')
		}
		return Token{matches[0], line, col, .nal_string_lit}
	}
	
	if [current[0]] in ['0'.bytes(), '1'.bytes(), '2'.bytes(), '3'.bytes(), '4'.bytes(), '5'.bytes(), '6'.bytes(), '7'.bytes(), '8'.bytes(), '9'.bytes()] {
		println('number!')
	}

	re.compile_opt("^[a-zA-Z_]+$") or { panic(err) }
	matches := re.find_all_str(current)
	if matches.len < 1 {
		panic('$file:$line:$col [ERROR] | failed to tokenise ident')
	}
	return Token{matches[0], line, col, .nal_identifier}
}