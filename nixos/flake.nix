{
  description = "internet_wizard's system flake";

  inputs = {
    nixpkgs.url = "github:nixos/nixpkgs?ref=nixos-25.05";
    nixpkgs-unstable.url = "github:nixos/nixpkgs";
    # custom neovim configuration flake
    nvim.url = "path:/home/internet_wizard/dotfiles/.config/nvim/";
    home-manager.url = "github:nix-community/home-manager";
    home-manager.inputs.nixpkgs.follows = "nixpkgs"; # Ensure Home Manager uses the same Nixpkgs as the system
    catppuccin.url = "github:catppuccin/nix";
  };

  outputs = { self, nixpkgs, nvim, home-manager, nixpkgs-unstable, catppuccin, ... }@inputs: {

    nixosConfigurations.han-tyumi = inputs.nixpkgs.lib.nixosSystem {
      system = "x86_64-linux";
      specialArgs = { inherit inputs nvim nixpkgs-unstable home-manager catppuccin ; };
      modules = [
        ./configuration.nix
        home-manager.nixosModules.home-manager
        {
          home-manager.useGlobalPkgs = true;
          home-manager.useUserPackages = true;
          home-manager.users.internet_wizard = import ./home.nix;
        }
        catppuccin.nixosModules.catppuccin
      ];
    };
  };
}
