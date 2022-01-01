module compiler

import os

import nal.ast
 
pub fn parse(file_name string) {
	if !os.is_file(file_name) {
		eprintln('file not found.')
		exit(1)
	}



}