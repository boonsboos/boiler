FLAGS := -skip-unused -enable-globals
OUTPUT := boiler

test-win:
	v $(FLAGS) -o $(OUTPUT).exe .
	./$(OUTPUT).exe ./examples/test.bo

# we use msvc on windows
build-win:
	v -cc msvc -prod $(FLAGS) -o $(OUTPUT).exe .

test-nix:
	v $(FLAGS) -o $(OUTPUT) .
	./$(OUTPUT) ./examples/test.bo

# we use gcc on *nix
build-nix:
	v -cc gcc -prod $(FLAGS) -o $(OUTPUT) .