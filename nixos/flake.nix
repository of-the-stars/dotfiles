{
  description = "System flake";

  inputs = {
    nixpkgs.url = "github:nixos/nixpkgs?ref=nixos-25.05";
    unstable.url = "github:nixos/nixpkgs";
    # custom nvim configuration flake
    nvim.url = "path:/home/internet_wizard/dotfiles/.config/nvim/";
    home-manager.url = "github:nix-community/home-manager";
    home-manager.inputs.nixpkgs.follows = "nixpkgs"; # Ensure Home Manager uses the same Nixpkgs as your system
    catppuccin.url = "github:catppuccin/nix";
  };

  outputs = { self, nixpkgs, unstable, nvim, home-manager, catpuccin, ... }@inputs: {

    nixosConfigurations.han-tyumi = inputs.nixpkgs.lib.nixosSystem {
      system = "x86_64-linux";
      specialArgs = { inherit inputs nvim unstable home-manager ; };
      modules = [
	{ _module.args = inputs nvim unstable home-manager ; }
        ./configuration.nix

        catpuccin.nixosModules.catppuccin
      ];
    };
  };
}
