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
  options = {
    modules.terminal.enable = lib.mkEnableOption "Enables terminal emulator and terminal applications";
    modules.terminal.extra.enable = lib.mkEnableOption "Enables extra terminal applications";
  };

  config = lib.mkIf config.modules.terminal.enable {
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
      (with pkgsUnstable; [
        presenterm
      ])
      ++ (
        with pkgs;
        [
          cargo # The Rust package manager
          exif # Analyze and manipulate image metadata
          cargo-generate # Generate rust projects
          cargo-info # Get info on crates
          dust # Modern `du`
          eza # Modern `ls`
          fastfetch # Fetch system details; `neofetch` replacement
          fd # Modern `find`
          fzf # Fast fuzzy finder
          gcc # GNU Compiler Collection
          gh # Github CLI
          git # The distributed VCS
          gping # `ping` but with a graph
          handlr # xdg-open alternative
          htop-vim # Interactive process viewer with vim bindings
          jq # Print and parse `.json`
          jujutsu # Git-compatible VCS
          just # Just a simple command runner
          lazygit # TUI for `git`
          nmap # Map the network
          openconnect # Connect to VPNs
          rename # Perl rename
          ripgrep # Modern `grep`
          rsync # Sync drives
          sd # sed alternative
          tree
          unzip
          whois # Domain registration lookup
          wl-clipboard # Manage system clipboard from the command line
          zoxide # A better `cd`
        ]
        ++ lib.optionals config.modules.terminal.extra.enable [
          # stow # Manage symlinks
          asciinema # Record your terminal session
          bitwarden-cli
          bsdgames # NetBSD games!
          cmatrix # Just a glitch
          cowsay # Moo!
          esp-generate # Generate #[no_std] ESP32 Rust projects
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
          screen # Terminal multiplexer, although I just use it for serial ports
          sl # Steam locomotive
          tiny # TUI IRC client
          tldr # Community-maintained manpage alternative with examples
          zellij # Terminal multiplexer
        ]
      );
  };
}
