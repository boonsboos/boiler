module util

import compiler

pub fn compile_parse_flags(flags []string) {
	for i in flags {
		if i.ends_with('.nal') {
			compiler.start_compile(i)
		} else {
			eprintln('no suitable file supplied. check if you typed the file name correctly and that it is a .nal file')
		}
	}
}
