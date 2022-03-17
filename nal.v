module main

import os

import util

fn main() {

	if os.args.len > 1 {
		match os.args[1] {
			'com' {
				util.compile_parse_flags(os.args[2..os.args.len])
			}
			else{ util.print_usage() }
		}
	} else { 
		util.print_usage()
	}
}