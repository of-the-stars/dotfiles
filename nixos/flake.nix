{
  description = "internet_wizard's system flake";

  inputs = {
    nixpkgs.url = "github:nixos/nixpkgs?ref=nixos-25.05";
    nixpkgs-unstable.url = "github:nixos/nixpkgs";
    # custom neovim configuration flake
    nvim.url = "path:/home/internet_wizard/dotfiles/.config/nvim/";
    home-manager.url = "github:nix-community/home-manager/release-25.05";
    home-manager.inputs.nixpkgs.follows = "nixpkgs"; # Ensure Home Manager uses the same Nixpkgs as the system
    home-manager-unstable.url = "github:nix-community/home-manager";
    catppuccin.url = "github:catppuccin/nix";
  };

  outputs = { self, nixpkgs, nixpkgs-unstable, home-manager, home-manager-unstable, nvim, catppuccin, ... }@inputs: {

    nixosConfigurations.han-tyumi = inputs.nixpkgs.lib.nixosSystem {
      system = "x86_64-linux";
      specialArgs = { inherit inputs nixpkgs-unstable home-manager home-manager-unstable nvim catppuccin ; };
      modules = [
        ./hardware-configuration.nix
        ./configuration.nix
        home-manager.nixosModules.home-manager
        {
          home-manager.useGlobalPkgs = true;
          home-manager.useUserPackages = true;
          home-manager.users.internet_wizard = {
            imports = [
              ./home.nix
              catppuccin.homeModules.catppuccin
              (inputs.home-manager-unstable + "/modules/programs/vivid.nix")
            ];
          };
        }
        catppuccin.nixosModules.catppuccin
      ];
    };
  };
}
