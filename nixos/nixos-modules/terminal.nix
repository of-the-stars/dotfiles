{
  config,
  pkgs,
  lib,
  ...
}: {
  imports = [
    # Paths to other modules.
    # Compose this module out of smaller ones.
  ];

  options = {
    # Option declarations.
    # Declare what settings a user of this module can set.
    # Usually this includes a global "enable" option which defaults to false.
    terminal.enable =
      lib.mkEnableOption "Enables terminal";
  };

  config = lib.mkIf config.terminal.enable {
    # Option definitions.
    # Define what other settings, services and resources should be active.
    # Usually these depend on whether a user of this module chose to "enable" it
    # using the "option" above.
    # Options for modules imported in "imports" can be set here.

    xdg.terminal-exec = {
      enable = true;
      settings = {
        default = [
          "kitty.desktop"
        ];
      };
    };

    programs.starship = {
      enable = true;
    };

    environment.variables = {
      SUDO_EDITOR = "nvim";
      EDITOR = "nvim";
      VISUAL = "nvim";
      SYSTEMD_EDITOR = "nvim";
      TERM = "kitty";
      PKG_CONFIG_PATH = "${pkgs.openssl.dev}/lib/pkgconfig";
    };

    environment.systemPackages = with pkgs; [
      # avrdude
      # avrlibc
      # cargo
      # cargo-generate
      # cargo-info
      # cargo-make
      # clang
      # clang-tools
      # gnumake
      # lua-language-server
      # luajitPackages.luarocks
      # mdbook
      # nil
      # pkgsCross.avr.buildPackages.binutils
      # pkgsCross.avr.buildPackages.gcc
      # ravedude
      # ruby
      # rust-analyzer
      # tree-sitter

      bitwarden-cli
      docker
      dust
      fastfetch
      fselect
      git
      gitleaks
      htop-vim
      lazygit
      mprocs
      nix-search-cli
      openconnect
      presenterm
      python3
      rename
      ripgrep
      ripgrep-all
      rustup
      rusty-man
      screen
      starship
      stow
      tiny
      unzip
      vim
      whois
      wl-clipboard
      bsdgames
      fortune-kind
      cowsay
    ];
  };
}
