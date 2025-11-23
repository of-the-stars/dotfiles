{
  config,
  pkgs,
  lib,
  inputs,
  ...
}:
let
  pkgsUnstable = import inputs.nixpkgs-unstable {
    inherit (pkgs.stdenv.hostPlatform) system;
    inherit (config.nixpkgs) config;
  };
in
{
  imports = [
    # Paths to other modules.
    # Compose this module out of smaller ones.
  ];

  options = {
    # Option declarations.
    # Declare what settings a user of this module can set.
    # Usually this includes a global "enable" option which defaults to false.
    terminal.enable = lib.mkEnableOption "Enables terminal";
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

      pkgsUnstable.presenterm

      asciinema
      bitwarden-cli
      bsdgames
      cargo
      cargo-generate
      cargo-info
      cowsay
      docker
      dust
      exiftool
      fastfetch
      fd
      ffmpeg
      figlet
      fortune-kind
      fselect
      gcc
      git
      gitleaks
      htop-vim
      jq
      lazygit
      mat2
      mprocs
      nix-search-cli
      nmap
      onefetch
      openconnect
      python3
      rename
      ripgrep
      ripgrep-all
      rustc
      rustup
      rusty-man
      sc-im
      screen
      sl
      starship
      stow
      tiny
      toot
      unzip
      vim
      whois
      wl-clipboard
    ];
  };
}
