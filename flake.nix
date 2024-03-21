{
	description = "Unix-like OS & global dev environment";

	inputs = {
		nixpkgs.url = "github:nixos/nixpkgs/nixos-unstable";
    neovim.url = "github:crpowers/envy";
	};

	outputs = { self, nixpkgs, ... } @ inputs: {
		nixosConfigurations = {
			nixbox = nixpkgs.lib.nixosSystem {
				system = "x86_64-linux";
				# Pass all inputs to the modules.
				specialArgs.inputs = inputs;
				modules = [
					./conf.nix
				];
			};
		};	
	};
}
