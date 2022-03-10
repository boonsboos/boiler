module error

import term

__global (
	parse_error int
	token_error int
)

fn init() {
	parse_error = 0
	token_error = 0
}

const (
	info = term.bright_cyan('[INF]') + reset
	warn = term.bright_yellow('[WRN]') + reset
	error = term.bright_red('[ERR]') + reset
	reset = term.reset('')
) 

pub fn compiler_error(filename string, line int, column int, message string) {
	parse_error++
	println('$filename:$line:$column |$error| $message')
}

pub fn compiler_warning(filename string, line int, column int, message string) {
	println('$filename:$line:$column |$warn| $message')
}

pub fn compiler_info(filename string, line int, column int, message string) {
	println('$filename:$line:$column |$info| $message')
}

pub fn compiler_crit_error(filename string, line int, column int, message string) {
	compiler_error(filename, line, column, message)
	exit(1)
}