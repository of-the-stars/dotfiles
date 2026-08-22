{
  config,
  pkgs,
  lib,
  inputs,
  ...
}:
let
  pkgsUnstable = inputs.nixpkgs-unstable.legacyPackages."${pkgs.stdenv.system}";
in
{
  options = {
    terminal.enable = lib.mkEnableOption "My terminal preferences";
  };

  config = lib.mkIf config.terminal.enable {
    programs.bat.enable = true;

    programs.zsh = {
      enable = true;
      package = pkgsUnstable.zsh;
      enableCompletion = true;
      autosuggestion.enable = true;
      syntaxHighlighting.enable = true;

      shellAliases = {
      };

      oh-my-zsh = {
        enable = true;
      };

      initContent = builtins.readFile ./../../../.zshrc;
    };

    home.shell = {
      enableZshIntegration = true;
    };

    home.shellAliases = {
      c = "clear";
      icat = "kitten icat";
      l = "eza -a --sort=type --group-directories-first";
      ls = "eza";
      v = "nvim";
    };

    programs.starship = {
      enable = true;
      enableZshIntegration = true;
    };

    programs.yazi = {
      enable = true;
      enableZshIntegration = true;
      shellWrapperName = "y";
    };

    programs.zoxide = {
      enable = true;
      enableZshIntegration = true;
    };

    programs.fzf = {
      enable = true;
      enableZshIntegration = true;
    };

    programs.eza = {
      enable = true;
      enableZshIntegration = true;
      git = true;
      icons = "auto";
      colors = "auto";
    };

    programs.kitty = {
      enable = true;
      shellIntegration.enableZshIntegration = true;
      enableGitIntegration = true;
    };

    programs.direnv = {
      enable = true;
      enableZshIntegration = true;
      nix-direnv.enable = true;
      silent = true;
    };

    programs.newsboat = {
      enable = true;
      autoReload = true;
      urls = (fromTOML (builtins.readFile ./../../../feeds.toml)).feeds;

      extraConfig = ''
        unbind-key k
        unbind-key j
        # unbind-key l
        # unbind-key h
        # unbind-key <Enter>

        bind k everywhere up
        bind j everywhere down
        # bind l open
        # bind h quit

        color background          white   default
        color listnormal          white   default
        color listfocus           black   white   bold
        color listnormal_unread   white   default bold
        color listfocus_unread    black   white   bold
        color title               black   white   bold
        color info                white   default bold
        color hint-key            white   default bold
        color hint-keys-delimiter white   default
        color hint-separator      white   default bold
        color hint-description    white   default
        color article             white   default
      '';
    };
  };
}
