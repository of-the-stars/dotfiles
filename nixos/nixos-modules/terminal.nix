{ config, pkgs, lib, ...}:
{
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

    environment.systemPackages = with pkgs; [ 
      bitwarden-cli
      cargo
      cargo-generate
      cargo-info
      cargo-make
      clang
      clang-tools
      direnv
      docker
      fastfetch
      fzf
      gcc
      git
      gitleaks
      gnumake
      htop-vim
      kitty 
      lazygit
      nix-search-cli
      openconnect
      python3
      rename
      ripgrep
      rustup
      screen
      stow
      tiny
      unzip
      vim
      whois
      wl-clipboard
      yazi
      zoxide
    ];

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

  };
}
