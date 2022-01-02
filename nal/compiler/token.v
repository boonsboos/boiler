module compiler

import nal.ast

pub struct NalToken {
	name    string
    kind    ast.Datatypes
	loc		Location
}

pub struct Location {
	row		int
	column	int
}