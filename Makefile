FLAGS := -skip-unused

test-win:
	v $(FLAGS) -o nalc.exe .

test-nix:
	v $(FLAGS) -o nalc .