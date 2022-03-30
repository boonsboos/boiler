module compiler

pub type Node = VariableNode

pub type Expr = Binary | Literal

// NON-terminal
pub type Literal = IntegerNode | FloatNode | StringNode | BoolNode

pub struct FileNode {
pub mut:
	nodes []Node
}

pub struct VariableNode {
pub mut:
	typ   string
	ident string
	value Expr
}

pub struct StringNode {
pub mut:
	value string
}

pub struct BoolNode {
pub mut:
	value bool
}

pub struct IntegerNode {
pub mut:
	value int
}

pub struct FloatNode {
pub mut:
	value f64
}

pub struct Binary {
pub mut:
	l Expr
	r Expr
	op Token
}