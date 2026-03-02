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
    izrss.url = "github:isabelroses/izrss";

    # custom neovim configuration flake
    nvim = {
      url = "path:./../.config/nvim/";
      inputs.nixpkgs.follows = "nixpkgs-unstable";
    };

    handy = {
      url = "github:cjpais/handy";
      inputs.nixpkgs.follows = "nixpkgs-unstable";
    };
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
          system = "x86_64-linux";
        in
        inputs.nixpkgs.lib.nixosSystem {
          inherit system;
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
              home-manager.extraSpecialArgs = {
                inherit
                  inputs
                  system
                  ;
              };
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

      # nixosConfigurations.cyboogie =
      #   let
      #     stellae = "internet_wizard";
      #     hostname = "cyboogie";
      #   in
      #   inputs.nixpkgs.lib.nixosSystem {
      #     system = "x86_64-linux";
      #     specialArgs = {
      #       inherit
      #         inputs
      #         nixpkgs
      #         nixpkgs-unstable
      #         stellae
      #         hostname
      #         ;
      #     };
      #     modules = [
      #       ./hosts/${hostname}
      #
      #       home-manager.nixosModules.home-manager
      #       {
      #         home-manager.useGlobalPkgs = true;
      #         home-manager.useUserPackages = true;
      #         home-manager.users.${stellae} = {
      #           home.username = "${stellae}";
      #           home.homeDirectory = "/home/${stellae}";
      #           imports = [
      #             ./home.nix
      #             inputs.catppuccin.homeModules.catppuccin
      #           ];
      #         };
      #       }
      #
      #       inputs.catppuccin.nixosModules.catppuccin
      #
      #       "${nixpkgs}/nixos/modules/installer/cd-dvd/installation-cd-minimal.nix"
      #     ];
      #   };

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
                ${syren} =
                  let
                    pkgs = import nixpkgs {
                      system = "x86_64-linux";
                    };
                    # Creates executable scripts under the `spellbook` attrset from my ./../spellbook/
                    spellbook = {
                      open-file = pkgs.writeShellApplication {
                        name = "open-file";
                        text = builtins.readFile ./../spellbook/open-file.sh;
                        runtimeInputs = with pkgs; [
                          eza
                          fd
                          handlr
                          rofi
                        ];
                      };

                      rebuild = pkgs.writeShellApplication {
                        name = "rebuild";
                        text = builtins.readFile ./../spellbook/rebuild.sh;
                        runtimeInputs = with pkgs; [
                          coreutils
                          fzf
                          git
                          jq
                          nix
                          pipewire
                          ripgrep
                        ];
                      };
                    };
                  in
                  {
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
                      "spellbook".source = ./../spellbook;
                    };
                    # programs.vscode =
                    #   let
                    #     pkgs = nixpkgs.legacyPackages."x86_64-linux";
                    #   in
                    #   {
                    #     enable = true;
                    #     package = pkgs.vscodium;
                    #     extensions = with pkgs.vscode-extensions; [
                    #       ms-vscode.live-server
                    #     ];
                    #   };
                    home.stateVersion = "25.05"; # Please read the comment before changing.
                  };
              };
            }
          ];
        };
    };
}
