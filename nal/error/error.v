module error

import term

const (
	notice = term.bright_cyan('[INF]') + reset
	warn = term.bright_yellow('[WRN]') + reset
	error = term.bright_red('[ERR]') + reset
	reset = term.reset('')
) 

pub fn compiler_error(filename string, line int, column int, message string) {
	println('$error $filename:$line:$column | $message')
}

pub fn compiler_warning(filename string, line int, column int, message string) {
	println('$warn $filename:$line:$column | $message')
}

pub fn compiler_notice(filename string, line int, column int, message string) {
	println('$notice $filename:$line:$column | $message')
}

pub fn compiler_crit_error(filename string, line int, column int, message string) {
	compiler_error(filename, line, column, message)
	exit(1)
}