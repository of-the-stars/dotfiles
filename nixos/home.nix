{
  config,
  pkgs,
  inputs,
  system,
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

  pkgsUnstable = inputs.nixpkgs-unstable.legacyPackages.${system};
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

    ".bashrc".source = ./../.bashrc;
    # ".zshrc".source = ./../.zshrc;
    ".bash_aliases".source = ./../.bash_aliases;

    ".stow-global-ignore".source = ./../.stow-global-ignore;
    "quickhacks".source = ./../quickhacks;

    # "cleanup.sh".source = ./../cleanup.sh;
    # "rebuild.sh".source = ./../rebuild.sh;
    # "init.sh".source = ./../init.sh;
  };

  services.tomat = {
    enable = true;
    package = pkgsUnstable.tomat;
    settings = {
      timer = {
        work = 25;
        break = 5;
        long_break = 15;
        sessions = 4;
        auto_advance = "none"; # Auto-advance mode: "none", "all", "to-break", "to-work"
      };
      sound = {
        mode = "none";
        volume = 0.5; # Volume level (0.0 to 1.0)
        # Optional: Custom sound files (will override embedded sounds)
        # work_to_break = "/path/to/custom/work-to-break.wav";
        # break_to_work = "/path/to/custom/break-to-work.wav";
        # work_to_long_break = "/path/to/custom/work-to-long-break.wav";
      };
      notification = {
        icon = "theme"; # Icon mode: "auto" (embedded), "theme" (system), or "/path/to/icon.png"
        urgency = "low";
        timeout = 10000; # Notification timeout in milliseconds
        work_message = "Break time! Step away from the screen.";
        break_message = "Back to work! Let's get things done.";
        long_break_message = "Long break! You've earned it.";
      };
      display = {
        text_format = "{state} {phase}: {time}";
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
