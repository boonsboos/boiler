module compiler

import regex
import error

fn match_token(file string, path string, line int, col int, current string) ?Token {
	match true {
		current.starts_with(' ') {
			return Token{' ', line, col, .whitespace}
		}
		current.starts_with('\t') {
			return Token{' ', line, col, .whitespace}
		}
		current.starts_with('\v') {
			return Token{' ', line, col, .whitespace}
		}
		current.starts_with('\f') {
			return Token{' ', line, col, .whitespace}
		}
		current.starts_with(';') {
			return Token{';' + current.find_between(';', '\n'), line, col, .comment}
		}
		current.starts_with('.') {
			return Token{'.', line, col, .nal_dot}
		}
		current.starts_with(',') {
			return Token{',', line, col, .nal_comma}
		}
		current.starts_with('{') {
			return Token{'{', line, col, .nal_open_curly}
		}
		current.starts_with('}') {
			return Token{'}', line, col, .nal_close_curly}
		}
		current.starts_with(':=') {
			return Token{':=', line, col, .nal_assign}
		}
		current.starts_with('=') {
			return Token{'=', line, col, .nal_equals}
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
		current.starts_with('(') {
			return Token{'(', line, col, .nal_open_paren}
		}
		current.starts_with(')') {
			return Token{')', line, col, .nal_close_paren}
		}
		current.starts_with('>') {
			return Token{'>', line, col, .nal_gt}
		}
		current.starts_with('>=') {
			return Token{'>=', line, col, .nal_gteq}
		}
		current.starts_with('<') {
			return Token{'<', line, col, .nal_lt}
		}
		current.starts_with('<=') {
			return Token{'<=', line, col, .nal_lteq}
		}
		current.starts_with('nal') {
			return Token{'nal', line, col, .nal_nal}
		}
		current.starts_with('fun') {
			return Token{'fun', line, col, .nal_fun}
		}
		current.starts_with('var') {
			return Token{'var', line, col, .nal_var}
		}
		current.starts_with('def') {
			return Token{'def', line, col, .nal_def}
		}
		current.starts_with('use') {
			return Token{'use', line, col, .nal_use}
		}
		current.starts_with('pub') {
			return Token{'pub', line, col, .nal_public}
		}
		current.starts_with('type') {
			return Token{'type', line, col, .nal_type}
		}
		current.starts_with('true') {
			return Token{'true', line, col, .nal_true}
		}
		current.starts_with('false') {
			return Token{'false', line, col, .nal_false}
		}
		else {
			token := regex_token(file, path, line, col, current) or {
				return Token{current, line, col, .nal_eof}
			}
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
			error.compiler_error(path, line, col, 'unclosed string!')
		}
		return Token{matches[0], line, col, .nal_string_lit}
	}

	if current[0].is_digit() {
		// parse int
		re.compile_opt('^[0-9]+([.]{0})') or { panic('bad regex in int parsing') }
		matches := re.find_all_str(current)
		if matches.len < 1 {
			// else see if it's a floating number
			re.compile_opt('^[0-9]+([.]{1}[0-9]+)') or { panic('bad regex in float parsing') }
			matched := re.find_all_str(current)
			if matched.len < 1 {
				error.compiler_error(path, line, col, 'not a float literal')
				exit(1)
			} else {
				return Token{matched[0], line, col, .nal_float_lit}
			}
			error.compiler_error(path, line, col, 'not an int literal')
			exit(1)
		}
		return Token{matches[0], line, col, .nal_int_lit}
	}

	// allowed naming includes snake_case, PascalCase, camelCase and kebab-case
	re.compile_opt('^[a-zA-Z_][\-a-zA-Z_0-9]+$') or { panic('bad regex in ident parsing') }
	matched := re.find_all_str(current)
	if matched.len < 1 {
		error.compiler_error(path, line, col, 'failed to tokenise ident ${current[0].ascii_str()}')
	}
	return Token{matched[0], line, col, .identifier}
}
