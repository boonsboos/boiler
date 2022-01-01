module compiler

struct Function {
	name	string
	// parameters	[]T // TODO: how do i do this
	// body			[]Operations
}

struct Variable {
	// nal_type T
	// value	T
}

struct Struct {
	name	string
	// members []Variable | Struct
	// functions	[]Function
}