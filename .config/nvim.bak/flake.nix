{
  description = "of-the-star's custom neovim flake";

  inputs = {
    nixpkgs.url = "github:nixos/nixpkgs/nixpkgs-unstable";
    nixCats.url = "github:BirdeeHub/nixCats-nvim";

    # neovim-nightly-overlay = {
    #   url = "github:nix-community/neovim-nightly-overlay";
    # };

    # If you want your plugin to be loaded by the standard overlay,
    # i.e. if it wasnt on nixpkgs, but doesnt have an extra build step.
    # Then you should name it "plugins-something"
    # If you wish to define a custom build step not handled by nixpkgs,
    # then you should name it in a different format, and deal with that in the
    # overlay defined for custom builds in the overlays directory.
    # for specific tags, branches and commits, see:
    # https://nixos.org/manual/nix/stable/command-ref/new-cli/nix3-flake.html#examples
  };

  outputs =
    {
      self,
      nixpkgs,
      nixCats,
      ...
    }@inputs:
    let
      inherit (nixCats) utils;
      luaPath = builtins.path {
        path = ./.;
        name = "nvim";
      };
      forEachSystem = utils.eachSystem nixpkgs.lib.platforms.all;

      # import nixpkgs { config = extra_pkg_config; inherit system; }

      # as that will have your system values
      extra_pkg_config = {
        # allowUnfree = true;
      };
      dependencyOverlays = [
        # This overlay grabs all the inputs named in the format
        # `plugins-<pluginName>`
        # Once we add this overlay to our nixpkgs, we are able to
        # use `pkgs.neovimPlugins`, which is a set of our plugins.
        (utils.standardPluginOverlay inputs)
        # add any other flake overlays here.

        # when other people mess up their overlays by wrapping them with system,
        # you may instead call this function on their overlay.
        # it will check if it has the system in the set, and if so return the desired overlay
        # (utils.fixSystemizedOverlay inputs.codeium.overlays
        #   (system: inputs.codeium.overlays.${system}.default)
        # )
      ];

      # see :help nixCats.flake.outputs.categories
      # and
      # :help nixCats.flake.outputs.categoryDefinitions.scheme
      categoryDefinitions =
        {
          pkgs,
          settings,
          categories,
          extra,
          name,
          mkPlugin,
          ...
        }@packageDef:
        {
          # to define and use a new category, simply add a new list to a set here,
          # and later, you will include categoryname = true; in the set you
          # provide when you build the package using this builder function.
          # see :help nixCats.flake.outputs.packageDefinitions for info on that section.

          # lspsAndRuntimeDeps:
          # this section is for dependencies that should be available
          # at RUN TIME for plugins. Will be available to PATH within neovim terminal
          # this includes LSPs
          lspsAndRuntimeDeps = with pkgs; {
            general = [
              bacon
              bash-language-server
              clang-tools
              clippy
              curl
              fd
              fzf
              just-formatter
              leptosfmt
              lua-language-server
              markdown-oxide
              marksman
              matlab-language-server
              mdformat
              nix-doc
              nixd
              nixfmt
              pandoc
              prettierd
              ripgrep
              rust-analyzer
              rustfmt
              sqls
              stdenv.cc.cc
              stylelint
              stylua
              taplo
              tombi
              universal-ctags
              yaml-language-server
            ];
            kickstart-debug = [
              delve
            ];
            kickstart-lint = [
              markdownlint-cli
              nix
            ];

            strudel = [
              nodejs
            ];
          };

          # This is for plugins that will load at startup without using packadd:
          startupPlugins = with pkgs.vimPlugins; {
            general = [
              alpha-nvim
              blink-cmp
              catppuccin-nvim
              clangd_extensions-nvim
              cmp-nvim-lsp
              cmp-path
              cmp_luasnip
              comment-nvim
              conform-nvim
              fidget-nvim
              flatten-nvim
              friendly-snippets
              fzf-vim
              fzfWrapper
              gitsigns-nvim
              heirline-nvim
              lazy-nvim
              lazydev-nvim
              luasnip
              markview-nvim
              mini-nvim
              nvim-lspconfig
              nvim-treesitter.withAllGrammars
              nvim-web-devicons
              plenary-nvim
              remote-nvim-nvim
              nui-nvim
              telescope-fzf-native-nvim
              telescope-nvim
              telescope-ui-select-nvim
              todo-comments-nvim
              toggleterm-nvim
              vim-sleuth
              which-key-nvim
              zoxide-vim
            ];
            kickstart-debug = [
              nvim-dap
              nvim-dap-ui
              nvim-dap-go
              nvim-nio
            ];
            kickstart-indent_line = [
              indent-blankline-nvim
            ];
            kickstart-lint = [
              nvim-lint
            ];
            kickstart-neo-tree = [
              neo-tree-nvim
              nui-nvim

              # nixCats will filter out duplicate packages
              # so you can put dependencies with stuff even if they're
              # also somewhere else
              nvim-web-devicons
              plenary-nvim
            ];
          };

          # shared libraries to be added to LD_LIBRARY_PATH
          # variable available to nvim runtime
          sharedLibraries = {
            general = with pkgs; [
              # libgit2
            ];
          };

          # environmentVariables:
          # this section is for environmentVariables that should be available
          # at RUN TIME for plugins. Will be available to path within neovim terminal
          environmentVariables = {
          };

          # If you know what these are, you can provide custom ones by category here.
          # If you dont, check this link out:
          # https://github.com/NixOS/nixpkgs/blob/master/pkgs/build-support/setup-hooks/make-wrapper.sh
          extraWrapperArgs = {
          };

          # lists of the functions you would have passed to
          # python.withPackages or lua.withPackages
          # do not forget to set `hosts.python3.enable` in package settings

          # get the path to this python environment
          # in your lua config via
          # vim.g.python3_host_prog
          # or run from nvim terminal via :!<packagename>-python3
          python3.libraries = {
          };
          # populates $LUA_PATH and $LUA_CPATH
          extraLuaPackages = {
          };
        };

      # And then build a package with specific categories from above here:
      # All categories you wish to include must be marked true,
      # but false may be omitted.
      # This entire set is also passed to nixCats for querying within the lua.

      # see :help nixCats.flake.outputs.packageDefinitions
      packageDefinitions = {
        # These are the names of your packages
        # you can include as many as you wish.
        nvim =
          {
            pkgs,
            name,
            ...
          }:
          {
            # they contain a settings set defined above
            # see :help nixCats.flake.outputs.settings
            settings = {
              suffix-path = true;
              suffix-LD = true;
              wrapRc = true;
              # IMPORTANT:
              # your alias may not conflict with your other packages.
              aliases = [ "vim" ];
              # neovim-unwrapped = inputs.neovim-nightly-overlay.packages.${pkgs.system}.neovim;
              hosts.python3.enable = true;
              hosts.node.enable = true;
            };
            # and a set of categories that you want
            # (and other information to pass to lua)
            categories = {
              general = true;

              kickstart-neo-tree = true;
              kickstart-debug = true;
              kickstart-lint = true;
              kickstart-indent_line = true;

              # this kickstart extra didnt require any extra plugins
              # so it doesnt have a category above.
              # but we can still send the info from nix to lua that we want it!
              kickstart-gitsigns = true;

              # we can pass whatever we want actually.
            };
          };
      };
      # In this section, the main thing you will need to do is change the default package name
      # to the name of the packageDefinitions entry you wish to use as the default.
      defaultPackageName = "nvim";
    in
    # see :help nixCats.flake.outputs.exports
    forEachSystem (
      system:
      let
        nixCatsBuilder = utils.baseBuilder luaPath {
          inherit
            nixpkgs
            system
            dependencyOverlays
            extra_pkg_config
            ;
        } categoryDefinitions packageDefinitions;
        defaultPackage = nixCatsBuilder defaultPackageName;
        # this is just for using utils such as pkgs.mkShell
        # The one used to build neovim is resolved inside the builder
        # and is passed to our categoryDefinitions and packageDefinitions
        pkgs = import nixpkgs { inherit system; };
      in
      {
        # these outputs will be wrapped with ${system} by utils.eachSystem

        # this will make a package out of each of the packageDefinitions defined above
        # and set the default package to the one passed in here.
        packages = utils.mkAllWithDefault defaultPackage;

        # choose your package for devShell
        # and add whatever else you want in it.
        devShells = {
          default = pkgs.mkShell {
            name = defaultPackageName;
            packages = [ defaultPackage ];
            inputsFrom = [ ];
            shellHook = '''';
          };
        };
      }
    )
    // (
      let
        # we also export a nixos module to allow reconfiguration from configuration.nix
        nixosModule = utils.mkNixosModules {
          moduleNamespace = [ defaultPackageName ];
          inherit
            defaultPackageName
            dependencyOverlays
            luaPath
            categoryDefinitions
            packageDefinitions
            extra_pkg_config
            nixpkgs
            ;
        };
        # and the same for home manager
        homeModule = utils.mkHomeModules {
          moduleNamespace = [ defaultPackageName ];
          inherit
            defaultPackageName
            dependencyOverlays
            luaPath
            categoryDefinitions
            packageDefinitions
            extra_pkg_config
            nixpkgs
            ;
        };
      in
      {
        # these outputs will be NOT wrapped with ${system}

        # this will make an overlay out of each of the packageDefinitions defined above
        # and set the default overlay to the one named here.
        overlays = utils.makeOverlays luaPath {
          inherit nixpkgs dependencyOverlays extra_pkg_config;
        } categoryDefinitions packageDefinitions defaultPackageName;

        nixosModules.default = nixosModule;
        homeModules.default = homeModule;

        inherit utils nixosModule homeModule;
        inherit (utils) templates;
      }
    );
}
