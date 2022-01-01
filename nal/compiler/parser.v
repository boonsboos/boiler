module compiler

import os

import nal.ast
 
pub fn parse(file_name string) {
	if !os.is_file(file_name) {
		eprintln('file not found.')
		exit(1)
	}

	file_contents := os.read_lines(file_name) or { panic('could not open file! $err') }

	mut words := []string{}
	mut line_counter := 0
	for line in file_contents {
		line_counter++
		mut sentence := line.trim_space()
		mut char_counter := 0
		for char in sentence {
			char_counter++
			match char {
				0x2c { // comma
					words << sentence.all_before(',')
					sentence = sentence.substr(sentence.index(',') or { panic('could not find index') }+1, sentence.len)
				}
				0x20 { // space
					words << sentence.all_before(' ')
					sentence = sentence.substr(sentence.index(' ') or { panic('could not find index') }+1, sentence.len)
				}
				0x5b {
					if sentence.index('[') or {0} +1 == 0x5d {
						println('array definition found')
					} else {
						throw_compiler_error('found opening square bracket but no closing square bracket...', .error, line_counter, char_counter, file_name)
					}
					words << sentence.all_before(' ')
					sentence = sentence.substr(sentence.index(']') or { panic('could not find index') }+1, sentence.len)
				}

				else { continue }
			}
		}
	}
	println(words)

}