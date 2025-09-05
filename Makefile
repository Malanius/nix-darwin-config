.PHONY: update switch init-devtools install-nix install-homebrew install-resh

update:
	nix flake update

switch:
	sudo darwin-rebuild switch --flake .
	rustup default stable
	./cargo-bins.sh

init-devtools:
	-xcode-select --install
	
# this is using using Determinate Systems' nix installer: https://zero-to-nix.com/concepts/nix-installer
install-nix: init-devtools
	curl --proto '=https' --tlsv1.2 -sSf -L https://install.determinate.systems/nix | sh -s -- install

install-homebrew:
	/bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/HEAD/install.sh)"

install-resh:
	curl -fsSL https://raw.githubusercontent.com/curusarn/resh/master/scripts/rawinstall.sh | bash

install-nvm:
	curl -o- https://raw.githubusercontent.com/nvm-sh/nvm/v0.40.3/install.sh | bash