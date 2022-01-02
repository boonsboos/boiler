module compiler

import os

import nal.ast

__global char_counter = 0
__global line_counter = 0

pub fn parse(file_name string) {
	if !os.is_file(file_name) {
		eprintln('file not found.')
		exit(1)
	}

	file_contents := os.read_lines(file_name) or { panic('could not open file! $err') }

	mut words := []NalToken{}
	for line in file_contents {
		line_counter++
		char_counter = 0
		mut sentence := line.trim_space()
		
		match true{
			sentence.starts_with('@') { println('found a comment :D') } //skip comment 
			sentence.contains_any('({') { words << match_function_definition(sentence) }
			
			else { println('could not find anything to parse on $sentence') }
		}
	}

	println(words)

}

fn match_function_definition(sentence string) NalToken {
	for char in sentence {
		char_counter++	

		match char {
			
			// if we find a `(`, we get everything before, and until the first `)`. 
			// then, we find the index of the first `()`, and get everything in-between, splitting on `,`
			
			0x28 { 

				name := sentence.split(' ')
				println(name)

				return NalToken{
					loc: Location {
						line_counter,
						char_counter
					}
				} 

			}

			else { continue }
		}
	}
	panic('failed to tokenise function definition!')
}