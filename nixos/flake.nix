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
    {
      nixosConfigurations.han-tyumi =
        let
          stellae = "internet_wizard";
          hostname = "han-tyumi";
        in
        inputs.nixpkgs.lib.nixosSystem {
          system = "x86_64-linux";
          specialArgs = {
            inherit
              inputs
              nixpkgs-unstable
              home-manager
              stellae
              hostname
              ;
          };
          modules = [
            ./hosts/${hostname}
            inputs.catppuccin.nixosModules.catppuccin
            home-manager.nixosModules.home-manager
            {
              home-manager.useGlobalPkgs = true;
              home-manager.useUserPackages = true;
              home-manager.backupFileExtension = "bak";
              home-manager.users.${stellae} = {
                home.username = "${stellae}";
                home.homeDirectory = "/home/${stellae}";
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

      nixosConfigurations.cyboogie =
        let
          stellae = "internet_wizard";
          hostname = "cyboogie";
        in
        inputs.nixpkgs.lib.nixosSystem {
          system = "x86_64-linux";
          specialArgs = {
            inherit
              inputs
              nixpkgs
              nixpkgs-unstable
              stellae
              hostname
              ;
          };
          modules = [
            ./hosts/${hostname}

            home-manager.nixosModules.home-manager
            {
              home-manager.useGlobalPkgs = true;
              home-manager.useUserPackages = true;
              home-manager.users.${stellae} = {
                home.username = "${stellae}";
                home.homeDirectory = "/home/${stellae}";
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
          stellae = "internet_wizard";
          syren = "syren";
          hostname = "matriarch";
        in
        inputs.nixpkgs.lib.nixosSystem {
          system = "x86_64-linux";
          specialArgs = {
            inherit
              inputs
              nixpkgs
              nixpkgs-unstable
              stellae
              syren
              hostname
              ;
          };
          modules = [
            ./hosts/${hostname}

            home-manager.nixosModules.home-manager
            {
              home-manager.backupFileExtension = "bak";
              home-manager.useGlobalPkgs = true;
              home-manager.useUserPackages = true;
              home-manager.users = {
                ${stellae} = {
                  home.username = "${stellae}";
                  home.homeDirectory = "/home/${stellae}";
                  imports = [
                    ./home.nix
                    inputs.catppuccin.homeModules.catppuccin
                  ];
                };

                ${syren} = {
                  imports = [
                    ./home-modules/terminal.nix
                  ];

                  home.username = "${syren}";
                  home.homeDirectory = "/home/${syren}";
                  xdg.configFile = {
                    "bat".source = ./../.config/bat;
                    "dunst".source = ./../.config/dunst;
                    "kitty".source = ./../.config/kitty;
                    "nvim".source = ./../.config/nvim;
                    "presenterm".source = ./../.config/presenterm;
                    "rofi".source = ./../.config/rofi;
                    "yazi".source = ./../.config/yazi;
                    # "kdeglobals".source = ./../.config/kdeglobals;
                  };
                  home.file = {
                    ".secrets".source = ./../.secrets;
                    ".bashrc".source = ./../.bashrc;
                    # ".zshrc".source = ./../.zshrc;
                    ".bash_aliases".source = ./../.bash_aliases;

                    "cleanup.sh".source = ./../cleanup.sh;
                    "rebuild.sh".source = ./../rebuild.sh;
                  };
                  programs.vscode =
                    let
                      pkgs = import nixpkgs {
                        system = "x86_64-linux";
                      };
                    in
                    {
                      enable = true;
                      package = pkgs.vscodium;
                      extensions = with pkgs.vscode-extensions; [
                        ms-vscode.live-server
                      ];
                    };
                  home.stateVersion = "25.05"; # Please read the comment before changing.
                };
              };
            }
          ];
        };
    };
}
