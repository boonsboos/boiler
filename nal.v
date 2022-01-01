module main

import os

import nal

fn main() {

	if os.args.len > 1 {
		match os.args[1] {
			'com' {
				nal.compile(os.args[2..os.args.len])
			}
			else{ nal.print_usage() }
		}
	} else { nal.print_usage() }
}