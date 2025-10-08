{
  description = "internet_wizard's system flake";

  inputs = {
    nixpkgs.url = "github:nixos/nixpkgs?ref=nixos-25.05";
    nixpkgs-unstable.url = "github:nixos/nixpkgs";

    home-manager.url = "github:nix-community/home-manager/release-25.05";
    home-manager.inputs.nixpkgs.follows = "nixpkgs"; # Ensure Home Manager uses the same Nixpkgs as the system
    home-manager-unstable.url = "github:nix-community/home-manager";

    catppuccin.url = "github:catppuccin/nix";

    # custom neovim configuration flake
    nvim.url = "path:/home/internet_wizard/dotfiles/.config/nvim/";

    # rmpc wrapper with cava
    rmpc.url = "path:/home/internet_wizard/dotfiles/.config/rmpc";
  };

  outputs = {
    self,
    nixpkgs,
    nixpkgs-unstable,
    home-manager,
    home-manager-unstable,
    ...
  } @ inputs: let
  in {
    nixosConfigurations.han-tyumi = inputs.nixpkgs.lib.nixosSystem {
      system = "x86_64-linux";
      specialArgs = {inherit inputs nixpkgs-unstable home-manager home-manager-unstable;};
      modules = [
        ./han-tyumi/configuration.nix
        ./han-tyumi/hardware-configuration.nix
        home-manager.nixosModules.home-manager
        {
          home-manager.useGlobalPkgs = true;
          home-manager.useUserPackages = true;
          home-manager.users.internet_wizard = {
            imports = [
              ./home.nix
              inputs.catppuccin.homeModules.catppuccin
              (home-manager-unstable + "/modules/programs/vivid.nix")
            ];
          };
        }

        inputs.catppuccin.nixosModules.catppuccin
      ];
    };

    nixosConfigurations.cyboogie = inputs.nixpkgs.lib.nixosSystem {
      system = "x86_64-linux";
      specialArgs = {inherit inputs nixpkgs nixpkgs-unstable;};
      modules = [
        ./cyboogie/configuration.nix
        ./han-tyumi/hardware-configuration.nix

        home-manager.nixosModules.home-manager
        {
          home-manager.useGlobalPkgs = true;
          home-manager.useUserPackages = true;
          home-manager.users.internet_wizard = {
            imports = [
              ./home.nix
              inputs.catppuccin.homeModules.catppuccin
              (home-manager-unstable + "/modules/programs/vivid.nix")
            ];
          };
        }

        inputs.catppuccin.nixosModules.catppuccin

        "${nixpkgs}/nixos/modules/installer/cd-dvd/installation-cd-minimal.nix"
      ];
    };
  };
}
