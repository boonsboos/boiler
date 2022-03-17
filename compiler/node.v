module compiler

pub type Node = VariableNode

pub type Value = VariableNode | Statement

pub type Statement = BinaryStatement

pub struct FileNode {
	nodes []Node
}

pub struct VariableNode {
	ident string
	value Value
}

pub struct BinaryStatement {
	l Value
	r Value
	op string
}