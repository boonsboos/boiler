module compiler

pub struct Variable {
	name string
	typ  string
}

pub interface AstNode {	}

pub struct FileNode {
pub mut:
	define DefineNode
	uses   []UseNode
	enums  []EnumNode
	functions []FunctionNode
}

pub struct DefineNode {
pub mut:
	name string
}

pub struct UseNode {
pub mut:
	mod      string
	imported string
}

pub struct EnumNode {
pub mut:
	name   string
	values []string
}

pub struct FunctionNode {
pub mut:
	name     string
	ret_type string
	def_type string // which struct the function is defined on
	params   []Variable
	// TODO: []statements
}