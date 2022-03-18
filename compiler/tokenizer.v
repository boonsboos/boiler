module compiler

pub struct Token {
pub:
	text	   string
	line	   int
	col 	   int
	typ TokenType
}

fn tokenize(file string, path string) []Token {

	mut tokens := []Token{}

	len := file.len
	mut idx := 0
	mut line := 1 // lines are 1-indexed
	mut col := 1 // columns are 1-indexed
	// reason for that is vs code

	for idx < len {

		current := file.substr(idx, file.len)

		if current.starts_with("\n") {
			col = 1
			line++
			idx++
			continue
		}

		token := match_token(file, path, line, col, current) or { continue }
		if token.typ == .whitespace {
			col++
			idx++
			continue
		}
		if token.typ == .comment {
			line++
			col = 1
			idx += token.text.len
			continue
		}

		col += token.text.len
		idx += token.text.len

		tokens << token
		
	}

	tokens << Token{'', 0, 0, .nal_eof}
	return tokens

}