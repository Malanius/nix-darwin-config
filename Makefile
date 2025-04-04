.PHONY: switch init-devtools install-nix

switch:
	darwin-rebuild switch --flake .

init-devtools:
	-xcode-select --install
	
# this is using using Determinate Systems' nix installer: https://zero-to-nix.com/concepts/nix-installer
install-nix: init-devtools
	curl --proto '=https' --tlsv1.2 -sSf -L https://install.determinate.systems/nix | sh -s -- install
