module compiler

pub interface AstNode {	}

pub struct FileNode {
pub mut:
	define DefineNode
	uses   []UseNode
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

pub struct FunctionNode {
pub mut:
	name string
	// TODO: params
	// TODO: return type
	// TODO: statements
}