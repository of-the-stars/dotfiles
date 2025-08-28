{
  description = "System flake";

  inputs = {
    nixpkgs.url = "github:nixos/nixpkgs?ref=nixos-25.05";
    unstable.url = "github:nixos/nixpkgs";
    # custom nvim configuration flake
    nvim.url = "path:/home/internet_wizard/dotfiles/nixos/nvim.nix";

  };

  outputs = { self, nixpkgs, unstable, nvim, ... }@inputs: {

    nixosConfigurations.han-tyumi = inputs.nixpkgs.lib.nixosSystem {
      system = "x86_64-linux";
      specialArgs = { inherit inputs nvim unstable; };
      modules = [
	{ _module.args = inputs nvim unstable; }
        ./configuration.nix
      ];
    };
  };
}
