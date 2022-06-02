module compiler

import regex
import error

const space = ` `

fn match_token(file string, path string, line int, col int, current string) ?Token {
	match true {
		current.starts_with(' ') ||
		current.starts_with('\t') ||
		current.starts_with('\v') ||
		current.starts_with('\f') {
			return Token{' ', line, col, .whitespace}
		}
		current.starts_with(';') {
			return Token{';' + current.find_between(';', '\n'), line, col, .comment}
		}
		current.starts_with('$') {
			return Token{'$', line, col, .dollar}
		}
		current.starts_with('|') {
			return Token{'|', line, col, .pipe}
		}
		current.starts_with('.') {
			return Token{'.', line, col, .dot}
		}
		current.starts_with(',') {
			return Token{',', line, col, .comma}
		}
		current.starts_with('{') {
			return Token{'{', line, col, .open_curly}
		}
		current.starts_with('}') {
			return Token{'}', line, col, .close_curly}
		}
		current.starts_with(':=') {
			return Token{':=', line, col, .assign}
		}
		current.starts_with('=') {
			return Token{'=', line, col, .equals}
		}
		current.starts_with('+') {
			return Token{'+', line, col, .plus}
		}
		current.starts_with('-') {
			return Token{'-', line, col, .minus}
		}
		current.starts_with('*') {
			return Token{'*', line, col, .mult}
		}
		current.starts_with('/') {
			return Token{'/', line, col, .div}
		}
		current.starts_with('%') {
			return Token{'%', line, col, .mod}
		}
		current.starts_with('(') {
			return Token{'(', line, col, .open_paren}
		}
		current.starts_with(')') {
			return Token{')', line, col, .close_paren}
		}
		current.starts_with('>') {
			return Token{'>', line, col, .gt}
		}
		current.starts_with('>=') {
			return Token{'>=', line, col, .gteq}
		}
		current.starts_with('<') {
			return Token{'<', line, col, .lt}
		}
		current.starts_with('<=') {
			return Token{'<=', line, col, .lteq}
		}
		current.starts_with('fn') {
			return Token{'fn', line, col, .bfn}
		}
		current.starts_with('var') {
			return Token{'var', line, col, .var}
		}
		current.starts_with('pack') {
			return Token{'pack', line, col, .pack}
		}
		current.starts_with('use') {
			return Token{'use', line, col, .use}
		}
		current.starts_with('type') {
			return Token{'type', line, col, .btype}
		}
		current.starts_with('if') {
			return Token{'if', line, col, .bif}
		}
		current.starts_with('else') {
			return Token{'else', line, col, .belse}
		}
		else {
			token := regex_token(file, path, line, col, current) or {
				return Token{current, line, col, .eof}
			}
			return token
		}
	}
	error.compiler_error(path, line, col, 'unrecognized thing: ${current.all_before(' ')}')
	exit(1)
}

fn regex_token(file string, path string, line int, col int, current string) ?Token {
	mut re := regex.new()
	if current.starts_with('"') {
		re.compile_opt('^"{1}.+"{1}$') or { panic(err) }
		matches := re.find_all_str(current)
		if matches.len < 1 {
			error.compiler_error(path, line, col, 'unclosed string!')
			exit(1)
		}
		return Token{matches[0], line, col, .str_literal}
	}

	if current[0].is_digit() {
		// else see if it's a floating number
		re.compile_opt('^[0-9]+([.][0-9]+)?') or { panic('bad regex in number parsing') }
		matched := re.find_all_str(current)
		if matched.len < 1 {
			error.compiler_error(path, line, col, 'not a number literal')
			exit(1)
		} else {
			return Token{matched[0], line, col, .literal}
		}
	}

	// allowed naming includes snake_case, PascalCase, camelCase and kebab-case
	re.compile_opt('^[a-zA-Z_][\-a-zA-Z_0-9]+$') or { panic('bad regex in ident parsing') }
	matched := re.find_all_str(current)
	if matched.len < 1 {
		error.compiler_error(path, line, col, 'failed to tokenise ident ${current[0].ascii_str()}')
	}
	return Token{matched[0], line, col, .identifier}
}
