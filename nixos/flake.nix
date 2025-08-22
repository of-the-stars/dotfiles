{
  description = "System flake";

  inputs = {
    nixpkgs.url = "github:nixos/nixpkgs?ref=nixos-25.05";
    
    # custom nvim configuration flake
    nvim.url = "path:./nvim.nix"
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
