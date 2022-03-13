FLAGS := -skip-unused -enable-globals
OUTPUT := -o nalc

test-win:
	v $(FLAGS) $(OUTPUT).exe .

build-win:
	v -cc msvc $(FLAGS) $(OUTPUT).exe .

test-nix:
	v $(FLAGS) $(OUTPUT) .