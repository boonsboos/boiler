module main

import os
import util
import compiler

fn main() {
	if os.args.len > 1 {
		compiler.start_compile(os.args[1])
	} else {
		util.print_usage()
	}
}
