{
  description = "internet_wizard's system flake";

  inputs = {
    nixpkgs.url = "github:nixos/nixpkgs?ref=nixos-25.11";
    nixpkgs-unstable.url = "github:nixos/nixpkgs";

    home-manager = {
      url = "github:nix-community/home-manager/release-25.11";
      inputs.nixpkgs.follows = "nixpkgs"; # Ensure Home Manager uses the same Nixpkgs as the system
    };

    catppuccin.url = "github:catppuccin/nix";
    timr-tui.url = "github:sectore/timr-tui";
    izrss.url = "github:isabelroses/izrss";

    # custom neovim configuration flake
    nvim.url = "path:./../.config/nvim/";
  };

  outputs =
    {
      self,
      nixpkgs,
      nixpkgs-unstable,
      home-manager,
      ...
    }@inputs:
    let
      username = "internet_wizard";
    in
    {
      nixosConfigurations.han-tyumi = inputs.nixpkgs.lib.nixosSystem {
        system = "x86_64-linux";
        specialArgs = {
          inherit
            inputs
            nixpkgs-unstable
            home-manager
            username
            ;
        };
        modules = [
          ./hosts/han-tyumi
          inputs.catppuccin.nixosModules.catppuccin
          home-manager.nixosModules.home-manager
          {
            home-manager.useGlobalPkgs = true;
            home-manager.useUserPackages = true;
            home-manager.backupFileExtension = "backup";
            home-manager.users.${username} = {
              home.username = "${username}";
              home.homeDirectory = "/home/${username}";
              imports = [
                ./home.nix
                inputs.catppuccin.homeModules.catppuccin
                inputs.izrss.homeManagerModules.default
                {
                  programs.izrss = {
                    enable = true;
                    settings.urls = [
                      "https://uncenter.dev/feed.xml"
                      "https://stephango.com/feed.xml"
                      "https://isabelroses.com/feed.xml"
                    ];
                  };
                }
              ];
            };
          }
        ];
      };

      nixosConfigurations.cyboogie = inputs.nixpkgs.lib.nixosSystem {
        system = "x86_64-linux";
        specialArgs = { inherit inputs nixpkgs nixpkgs-unstable; };
        modules = [
          ./hosts/cyboogie

          home-manager.nixosModules.home-manager
          {
            home-manager.useGlobalPkgs = true;
            home-manager.useUserPackages = true;
            home-manager.users.${username} = {
              imports = [
                ./home.nix
                inputs.catppuccin.homeModules.catppuccin
              ];
            };
          }

          inputs.catppuccin.nixosModules.catppuccin

          "${nixpkgs}/nixos/modules/installer/cd-dvd/installation-cd-minimal.nix"
        ];
      };

      nixosConfigurations.matriarch =
        let
          gf_username = "syren";
        in
        inputs.nixpkgs.lib.nixosSystem {
          system = "x86_64-linux";
          specialArgs = {
            inherit
              inputs
              nixpkgs
              nixpkgs-unstable
              username
              gf_username
              ;
          };
          modules = [
            ./hosts/matriarch

            # home-manager.nixosModules.home-manager
            # {
            #   home-manager.useGlobalPkgs = true;
            #   home-manager.useUserPackages = true;
            #   home-manager.users = {
            #     ${username} = {
            #       # imports = [
            #       #   ./home.nix
            #       #   inputs.catppuccin.homeModules.catppuccin
            #       # ];

            #     };
            #     ${gf_username} = { };
            #   };
            # }
          ];
        };
    };
}
