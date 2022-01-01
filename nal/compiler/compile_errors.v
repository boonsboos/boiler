module compiler

import term

pub enum CompileErrorLevel {
	notice
	warning
	error
}

pub fn throw_compiler_error(message string, level CompileErrorLevel, location_line int, location_column int, filename string) {

	if level == .notice {
		eprintln('$filename @ $location_line:$location_column - ${term.bright_cyan('NOTICE')} | $message')
	} else if level == .warning {
		eprintln('$filename @ $location_line:$location_column - ${term.bright_yellow('WARNING')} | $message')
	} else {
		eprintln('$filename @ $location_line:$location_column - ${term.bright_red('ERROR')} | $message')
	}

}