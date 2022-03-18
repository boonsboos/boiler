FLAGS := -skip-unused -enable-globals
OUTPUT := nalc

test-win:
	v $(FLAGS) -o $(OUTPUT).exe .
	./$(OUTPUT).exe com ./examples/test.nal

# we use msvc on windows
build-win:
	v -cc msvc $(FLAGS) -o $(OUTPUT).exe .

test-nix:
	v $(FLAGS) -o $(OUTPUT) .
	./$(OUTPUT) com ./examples/test.nal

# we use gcc on *nix
build-nix:
	v -cc gcc $(FLAGS) -o $(OUTPUT) .