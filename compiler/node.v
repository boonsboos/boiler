module compiler

pub type Node = VariableNode

pub type Value = BinaryStatement | StringNode | IntegerNode | FloatNode

pub struct FileNode {
pub mut:
	nodes []Node
}

pub struct VariableNode {
pub mut:
	typ   string
	ident string
	value Value
}

pub struct StringNode {
pub mut:
	value string
}

pub struct IntegerNode {
	value int
}

pub struct FloatNode {
	value f64
}

pub struct BinaryStatement {
pub mut:
	l Value
	r Value
	op TokenType
}