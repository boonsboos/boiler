FLAGS := -skip-unused -enable-globals
OUTPUT := -o nalc

test-win:
	v $(FLAGS) $(OUTPUT).exe .

# we use msvc on windows
build-win:
	v -cc msvc $(FLAGS) $(OUTPUT).exe .

test-nix:
	v $(FLAGS) $(OUTPUT) .

build-nix:
	v -cc gcc $(FLAGS) $(OUTPUT) .