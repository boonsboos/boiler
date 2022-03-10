FLAGS := -skip-unused -enable-globals

test-win:
	v $(FLAGS) -o nalc.exe .

test-nix:
	v $(FLAGS) -o nalc .