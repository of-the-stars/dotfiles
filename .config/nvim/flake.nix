{
  description = "Neovim wrapper";

  inputs = {
    nixpkgs.url = "github:nixos/nixpkgs?ref=nixos-unstable";
  };

  outputs =
    {
      self,
      nixpkgs,
    }:
    let
      systems = [
        "x86_64-linux"
      ];
      iterOverSystems = nixpkgs.lib.genAttrs systems;
      forSystem =
        system:
        let
          inherit (pkgs) lib;
          pkgs = import nixpkgs { inherit system; };
          configPath = builtins.path {
            path = lib.cleanSource ./.;
            name = "nvim";
          };

          runtimePackages = with pkgs; [
            # nix-doc
            coreutils
            curl
            fd
            fzf
            git
            gnutar
            lazygit
            lua-language-server
            tree-sitter
            nil
            nixd
            nixfmt
            ripgrep
            rust-analyzer
            stylua
            tinymist
            clang-tools
            typst
            typstyle
            wl-clipboard
            xdg-utils
          ];

          plugins = with pkgs.vimPlugins; [
            alpha-nvim
            blink-cmp
            catppuccin-nvim
            conform-nvim
            flatten-nvim
            gitsigns-nvim
            lazydev-nvim
            mini-comment
            mini-files
            mini-icons
            mini-statusline
            mini-tabline
            nvim-lspconfig
            nvim-treesitter.withAllGrammars
            # nvim-treesitter-context
            plenary-nvim
            telescope-nvim
            toggleterm-nvim
            which-key-nvim
          ];

          rtp = pkgs.symlinkJoin {
            name = "runtimePath";
            paths = plugins;
          };

          neovim = pkgs.stdenv.mkDerivation (finalAttrs: {
            inherit (pkgs.neovim-unwrapped) version;

            pname = "nvim";

            src = configPath;

            installPhase = ''
              mkdir -p $out/bin

              cp ${configPath}/init.lua $out/.
              cp -r ${configPath}/lsp $out/.
              cp -r ${configPath}/lua $out/.
              cp -r ${configPath}/ftplugin $out/.
              cp -r ${configPath}/plugin $out/.
              cp -r ${pkgs.neovim-unwrapped}/share $out/.

              cp ${pkgs.writeShellScriptBin "nvim" ''
                export PATH=${lib.strings.makeBinPath runtimePackages}:$PATH
                export NIX_NVIM_RUNTIME_PATH="${configPath},${rtp}"
                exec ${pkgs.neovim-unwrapped}/bin/nvim -u ${configPath}/init.lua "$@"
              ''}/bin/nvim $out/bin/.
            '';

            meta = {
              description = "of-the-stars's custom neovim configuration, wrapped up with a nice little bow";
              homepage = "https://of-the-stars.net/";
              license = lib.licenses.unlicense;
              maintainers = with lib.maintainers; [ of-the-stars ];
            };
          });

        in
        {
          package = neovim;
          formatter = pkgs.nixfmt-tree; # Nix flake formatter. Run `nix fmt` to use
        };
    in
    {
      formatter = iterOverSystems (system: (forSystem system).formatter);

      packages = iterOverSystems (system: {
        default = (forSystem system).package;
      });
    };
}
