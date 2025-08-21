{
  description = "System flake";

  inputs = {
    nvim.url = "path:~/.config/kickstart-nixcats"
    nixpkgs.url = "github:nixos/nixpkgs?ref=nixos-25.05";
  };

  outputs = { self, nixpkgs, ... }@inputs: {

    nixosConfigurations.han-tyumi = nixpkgs.lib.nixosSystem {
      system = "x86_64-linux";
      modules = [
        ./configuration.nix
      ];
    };

    packages.han-tyumi.nvim = derivation;

  };
}
