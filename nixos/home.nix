{
  config,
  pkgs,
  ...
}:
let
  open-file = pkgs.writeShellApplication {
    name = "open-file";
    text = builtins.readFile ./../open-file.sh;
    runtimeInputs = with pkgs; [
      eza
      rofi
      fd
      handlr
    ];
  };

  rebuild = pkgs.writeShellApplication {
    name = "rebuild";
    text = builtins.readFile ./../rebuild.sh;
    runtimeInputs = with pkgs; [
      git
      ripgrep
      nix
      jq
      fzf
      pipewire
      coreutils
    ];
  };

in
{
  imports = [
    ./home-modules
  ];

  home.packages = [
    open-file
    rebuild
  ];

  xdg.configFile = {
    "ashell".source = ./../.config/ashell;
    "bat".source = ./../.config/bat;
    "dunst".source = ./../.config/dunst;
    "halloy".source = ./../.config/halloy;
    "hypr".source = ./../.config/hypr;
    "kitty".source = ./../.config/kitty;
    "mimeapps.list".source = ./../.config/mimeapps.list;
    "ncspot".source = ./../.config/ncspot;
    "niri".source = ./../.config/niri;
    "nvim".source = ./../.config/nvim;
    "presenterm".source = ./../.config/presenterm;
    "rmpc".source = ./../.config/rmpc;
    "rofi".source = ./../.config/rofi;
    "sc-im".source = ./../.config/sc-im;
    "tiny".source = ./../.config/tiny;
    "tmux".source = ./../.config/tmux;
    "waybar".source = ./../.config/waybar;
    "yazi".source = ./../.config/yazi;
    "zathura".source = ./../.config/zathura;
    "zellij".source = ./../.config/zellij;
  };

  home.file = {
    ".secrets".source = ./../.secrets;
    ".gitconfig".source = ./../.gitconfig;
    ".lyrics".source = ./../.lyrics;

    ".bashrc".source = ./../.bashrc;
    # ".zshrc".source = ./../.zshrc;
    ".bash_aliases".source = ./../.bash_aliases;

    ".stow-global-ignore".source = ./../.stow-global-ignore;

    # "cleanup.sh".source = ./../cleanup.sh;
    # "rebuild.sh".source = ./../rebuild.sh;
    # "init.sh".source = ./../init.sh;
  };

  services.tomat = {
    enable = true;
    settings = {
      timer = {
        work = 25;
        break = 5;
        auto_advance = false;
      };
      display = {
        text_format = "{phase}: {time} {state}";
      };
      notification = {
        icon = "theme";
        urgency = "low";
        work_message = "Break time! Step away from the screen.";
        break_message = "Back to work! Let's get things done.";
        long_break_message = "Long break! You've earned it.";
      };
    };
  };

  # This value determines the Home Manager release that your configuration is
  # compatible with. This helps avoid breakage when a new Home Manager release
  # introduces backwards incompatible changes.
  #
  # You should not change this value, even if you update Home Manager. If you do
  # want to update the value, then make sure to first check the Home Manager
  # release notes.
  home.stateVersion = "25.05"; # Please read the comment before changing.
}
