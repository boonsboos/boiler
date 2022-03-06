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
	mut col := 0

	for idx < len {

		current := file.substr(idx, file.len)

		if current.starts_with("\n") {
			col = 0
			line++
			idx++
			continue
		}

		token := match_token(file, path, line, col, current) or { continue }
		println(token)
		if token.token_type == .whitespace {
			col++
			idx++
			tokenizer.tokens << token
			continue
		}
		if token.token_type == .comment {
			line++
			col = 0
			idx += token.text.len
			tokenizer.tokens << token
			continue
		}

		col += token.text.len
		idx += token.text.len
		
		tokenizer.tokens << token
		
	}

}