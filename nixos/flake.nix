{
  description = "of-the-stars's system flake";

  inputs = {
    nixpkgs.url = "github:nixos/nixpkgs?ref=nixos-26.05";
    nixpkgs-unstable.url = "github:nixos/nixpkgs";

    home-manager = {
      url = "github:nix-community/home-manager/release-26.05";
      inputs.nixpkgs.follows = "nixpkgs"; # Ensure Home Manager uses the same Nixpkgs as the system
    };

    catppuccin = {
      url = "github:catppuccin/nix/release-26.05";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    izrss = {
      url = "github:isabelroses/izrss";
      inputs.nixpkgs.follows = "nixpkgs-unstable";
    };

    veila = {
      url = "github:naurissteins/Veila";
      inputs.nixpkgs.follows = "nixpkgs-unstable";
    };

    # custom neovim configuration flake
    nvim = {
      url = "path:./../.config/nvim/";
      inputs.nixpkgs.follows = "nixpkgs-unstable";
    };
  };

  outputs =
    {
      self,
      ...
    }@inputs:
    let
      userPath = ./users;
      # hostPath = ./hosts;
      users = inputs.nixpkgs.lib.mapAttrs' (
        name: value:
        inputs.nixpkgs.lib.nameValuePair (inputs.nixpkgs.lib.toCamelCase name) {
          path = userPath + ("/" + name);
        }
      ) (inputs.nixpkgs.lib.filterAttrs (name: type: type == "directory") (builtins.readDir userPath));
      # TODO: Make this the default for creating host configs under the nixosConfigurations set
      # hosts = inputs.nixpkgs.lib.mapAttrs' (
      #   name: value:
      #   inputs.nixpkgs.lib.nameValuePair (inputs.nixpkgs.lib.toCamelCase name) (hostPath + ("/" + name))
      # ) (inputs.nixpkgs.lib.filterAttrs (name: type: type == "directory") (builtins.readDir hostPath));
    in
    {
      nixosConfigurations = {
        han-tyumi = inputs.nixpkgs.lib.nixosSystem (import ./hosts/han-tyumi { inherit inputs users; });
        # matriarch = inputs.nixpkgs.lib.nixosSystem (import ./hosts/matriarch { inherit inputs users; });
      };
    };
}
