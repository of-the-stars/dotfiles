{
  description = "System flake";

  inputs = {
    nixpkgs.url = "github:nixos/nixpkgs?ref=nixos-25.05";
    
    # custom nvim configuration flake
    nvim.url = "github:internetwiz4rd/nvim-config/master"
  };

  outputs = inputs@{ self, nixpkgs, ... }: {

    nixosConfigurations.han-tyumi = nixpkgs.lib.nixosSystem {
      system = "x86_64-linux";
      specialArgs = { inherit inputs; };
      modules = [
        ./configuration.nix
      ];
    };

  };
}
