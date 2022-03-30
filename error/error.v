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

pub enum MessageLevel {
	info
	warn
	err
	fatal
}

const (
	info = term.bright_cyan('[INF]') + reset
	warn = term.bright_yellow('[WRN]') + reset
	error = term.bright_red('[ERR]') + reset
	critical = term.bg_red(term.black('[FTL]')) + reset
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

[noreturn]
pub fn compiler_fatal(filename string, line int, column int, message string) {
	println('$filename:$line:$column |$critical| $message')
	exit(1)
}

pub fn compiler_message(message string, level MessageLevel) {
	match level {
		.info {
			println('$info -> $message')
		}
		.warn {
			println('$warn -> $message')
		}
		.err {
			println('$error -> $message')
		}
		.fatal {
			println('$critical -> $message')
		}
	}
}