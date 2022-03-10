module compiler

pub struct Variable {
pub mut:
	typ  string
	name string
}

pub interface AstNode {	}

pub struct FileNode {
pub mut:
	define     DefineNode
	uses       []UseNode
	interfaces []InterfaceNode
	structs    []StructNode
	enums      []EnumNode
	functions  []FunctionNode
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

pub struct StructNode {
pub mut:
	name    string
	members []Variable
}

pub struct EnumNode {
pub mut:
	name   string
	values []string
}

pub struct FunctionNode {
pub mut:
	name      string
	ret_type  string
	def_type  string // which struct the function is defined on
	params    []Variable
	statement []Statement
}

pub struct InterfaceNode {
pub mut:
	name      string
	members   []Variable
	functions []Statement
}