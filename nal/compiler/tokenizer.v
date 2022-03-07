module compiler

import os

pub struct Token {
pub:
	text	   string
	line	   int
	col 	   int
	token_type TokenType
}

struct Tokenizer {
mut:
	tokens []Token
}

pub fn start_compile(i string) {

	mut file := os.read_file(i) or { 
		eprintln('failed to find file')
		exit(1)
	}
	file = file.replace("\r\n", "\n") // replace windows linefeeds
	
	tokenize(file, i)

}

fn tokenize(file string, path string) {

	mut tokenizer := Tokenizer{}

	len := file.len
	mut idx := 0
	mut line := 0
	mut col := 1 // columns are 1-indexed

	for idx < len {

		current := file.substr(idx, file.len)

		if current.starts_with("\n") {
			col = 1
			line++
			idx++
			continue
		}

		token := match_token(file, path, line, col, current) or { continue }
		if token.token_type == .whitespace {
			col++
			idx++
			continue
		}
		if token.token_type == .comment {
			line++
			col = 1
			idx += token.text.len
			continue
		}

		col += token.text.len
		idx += token.text.len
		println(token)
		tokenizer.tokens << token
		
	}

}