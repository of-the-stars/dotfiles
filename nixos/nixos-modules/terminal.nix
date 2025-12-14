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

      pkgsUnstable.presenterm

      asciinema # Record your terminal session
      bitwarden-cli
      bsdgames # NetBSD games!
      cargo # The Rust package manager
      cargo-generate # Generate rust projects
      cargo-info # Get info on crates
      cowsay # Moo!
      docker
      dust # Modern `du`
      exiftool
      fastfetch # Fetch system details; `neofetch` replacement
      fd # Modern `find`
      figlet # Make ASCII art from text
      fortune-kind # `fortune` but kinder
      fselect # Find files with SQL-like syntax
      gcc # GNU Compiler Collection
      git # The distributed VCS
      gitleaks # Look for secrets in a git repo
      gping # `ping` but with a graph
      htop-vim # Interactive process viewer with vim bindings
      jq # Print and parse `.json`
      lazygit # TUI for `git`
      mat2 # Metadata removal tool
      mdbook # Create markdown books
      mprocs # Run multiple commands in parallel
      nix-search-cli # Search nixpkgs
      nmap # Map the network
      onefetch # Git repo summary
      openconnect # Connect to VPNs
      procs # Modern `ps`
      python3 # Python interpreter
      rename
      ripgrep # Modern `grep`
      ripgrep-all
      rustc # Rust compiler
      rusty-man
      sc-im # Spreadsheet calculator, improved
      screen # Terminal multiplexer, although I just use it for serial ports
      sl # Steam locomotive
      stow # Manage symlinks
      tiny # TUI IRC client
      tldr # Community-maintained manpage alternative with examples
      tree
      unzip
      whois # Domain registration lookup
      wl-clipboard # Manage system clipboard from the command line
      zellij # Terminal multiplexer
      esp-generate # Generate #[no_std] ESP32 Rust projects
    ];
  };
}
