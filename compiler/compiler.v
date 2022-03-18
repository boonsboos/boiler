module compiler

import os

pub fn start_compile(i string) {

	mut file := os.read_file(i) or { 
		eprintln('failed to find file')
		exit(1)
	}
	file = file.replace("\r\n", "\n") // replace windows linefeeds
	
	mut tokens := tokenize(file, i)
	if token_error > 0 {
		println('more than 1 error detected, aborting early...')
		exit(1)
	}
	//println(tokens)
	nodes := parse(i, mut tokens)
	println(nodes)

}
