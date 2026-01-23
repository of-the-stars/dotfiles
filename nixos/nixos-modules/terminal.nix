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
    modules.terminal.enable = lib.mkEnableOption "Enables terminal emulator and terminal applications";
    modules.terminal.extra.enable = lib.mkEnableOption "Enables extra terminal applications";
  };

  config = lib.mkIf config.modules.terminal.enable {
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
      TERMINAL = "kitty.desktop";
      PKG_CONFIG_PATH = "${pkgs.openssl.dev}/lib/pkgconfig";
    };

    environment.systemPackages =
      with pkgs;
      [
        kitty

        pkgsUnstable.presenterm

        cargo # The Rust package manager
        cargo-generate # Generate rust projects
        cargo-info # Get info on crates
        dust # Modern `du`
        fastfetch # Fetch system details; `neofetch` replacement
        fd # Modern `find`
        fzf
        gcc # GNU Compiler Collection
        git # The distributed VCS
        gping # `ping` but with a graph
        htop-vim # Interactive process viewer with vim bindings
        jq # Print and parse `.json`
        lazygit # TUI for `git`
        nmap # Map the network
        openconnect # Connect to VPNs
        rename
        ripgrep # Modern `grep`
        tree
        unzip
        whois # Domain registration lookup
        wl-clipboard # Manage system clipboard from the command line
        zoxide
      ]
      ++ lib.optionals config.modules.terminal.extra.enable [
        asciinema # Record your terminal session
        bitwarden-cli
        bsdgames # NetBSD games!
        btop
        cmatrix # Just a glitch
        cowsay # Moo!
        docker
        esp-generate # Generate #[no_std] ESP32 Rust projects
        exiftool
        figlet # Make ASCII art from text
        fortune-kind # `fortune` but kinder
        fselect # Find files with SQL-like syntax
        gitleaks # Look for secrets in a git repo
        mat2 # Metadata removal tool
        mdbook # Create markdown books
        mprocs # Run multiple commands in parallel
        nix-search-cli # Search nixpkgs
        onefetch # Git repo summary
        procs # Modern `ps`
        python3 # Python interpreter
        ripgrep-all
        rusty-man
        sc-im # Spreadsheet calculator, improved
        screen # Terminal multiplexer, although I just use it for serial ports
        sl # Steam locomotive
        # stow # Manage symlinks
        tiny # TUI IRC client
        tldr # Community-maintained manpage alternative with examples
        zellij # Terminal multiplexer
      ];
  };
}
