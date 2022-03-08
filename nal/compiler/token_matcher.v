module compiler

import regex

import error

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
			return Token{'@'+current.find_between("@", "\n"), line, col, .comment}
		}
		current.starts_with(".") {
			return Token{".", line, col, .nal_dot}
		}
		current.starts_with(",") {
			return Token{",", line, col, .nal_comma}
		}
		current.starts_with("{") {
			return Token{"{", line, col, .nal_open_curly}
		}
		current.starts_with("}") {
			return Token{"}", line, col, .nal_close_curly}
		}
		current.starts_with("=") {
			return Token{"=", line, col, .nal_equals}
		}
		current.starts_with('+') {
			return Token{'+', line, col, .nal_plus}
		}
		current.starts_with('-') {
			return Token{'-', line, col, .nal_minus}
		}
		current.starts_with('*') {
			return Token{'*', line, col, .nal_mult}
		}
		current.starts_with('/') {
			return Token{'/', line, col, .nal_div}
		}
		current.starts_with('%') {
			return Token{'%', line, col, .nal_mod}
		}
		current.starts_with("(") {
			return Token{"(", line, col, .nal_open_paren}
		}
		current.starts_with(")") {
			return Token{")", line, col, .nal_close_paren}
		}
		current.starts_with(">") {
			return Token{">", line, col, .nal_gt}
		}
		current.starts_with(">=") {
			return Token{">=", line, col, .nal_gteq}
		}
		current.starts_with("<") {
			return Token{"<", line, col, .nal_lt}
		}
		current.starts_with("<=") {
			return Token{"<=", line, col, .nal_lteq}
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
		current.starts_with("struct") {
			return Token{"struct", line, col, .nal_struct}
		}
		current.starts_with("interface") {
			return Token{"interface", line, col, .nal_interface}
		}
		current.starts_with("enum") {
			return Token{"enum", line, col, .nal_enum}
		}
		current.starts_with("true") {
			return Token{"true", line, col, .nal_true}
		}
		current.starts_with("false") {
			return Token{"false", line, col, .nal_false}
		}
		else {
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
			error.compiler_crit_error(path, line, col, 'unclosed string!')
		}
		return Token{matches[0], line, col, .nal_string_lit}
	}
	
	if [current[0]] in ['0'.bytes(), '1'.bytes(), '2'.bytes(), '3'.bytes(), '4'.bytes(), '5'.bytes(), '6'.bytes(), '7'.bytes(), '8'.bytes(), '9'.bytes()] {
		return Token{current[0].ascii_str(), line, col, .nal_number_lit}
	}

	re.compile_opt("^[a-zA-Z_]+$") or { panic(err) }
	matches := re.find_all_str(current)
	if matches.len < 1 {
		panic('$path:$line:$col [ERROR] | failed to tokenise ident ${current[0].ascii_str()}')
	}
	return Token{matches[0], line, col, .nal_identifier}
}