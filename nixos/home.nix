{
  config,
  pkgs,
  ...
}:
{
  imports = [
    ./home-modules
  ];

  home.username = "internet_wizard";
  home.homeDirectory = "/home/internet_wizard";

  home.packages = with pkgs; [
    bat
    opencomposite
  ];

  xdg.configFile = {
    "hypr".source = ./../.config/hypr;
    "nvim".source = ./../.config/nvim;
    "dunst".source = ./../.config/dunst;
    "halloy".source = ./../.config/halloy;
    "ncspot".source = ./../.config/ncspot;
    "tiny".source = ./../.config/tiny;
    "kitty".source = ./../.config/kitty;
    "waybar".source = ./../.config/waybar;
    "rofi".source = ./../.config/rofi;
    "yazi".source = ./../.config/yazi;
    "sc-im".source = ./../.config/sc-im;
    "tmux".source = ./../.config/tmux;
    "presenterm".source = ./../.config/presenterm;
    # "kdeglobals".source = ./../.config/kdeglobals;
  };

  home.file = {
    ".secrets".source = ./../.secrets;
    ".gitconfig".source = ./../.gitconfig;

    ".bashrc".source = ./../.bashrc;
    # ".zshrc".source = ./../.zshrc;
    ".bash_aliases".source = ./../.bash_aliases;

    ".stow-global-ignora".source = ./../.stow-global-ignore;

    "cleanup.sh".source = ./../cleanup.sh;
    "rebuild.sh".source = ./../rebuild.sh;
  };

  programs.vivid.enable = false;

  # xdg.configFile."openvr/openvrpaths.vrpath".text = ''
  #   {
  #     "config" :
  #     [
  #       "~/.local/share/Steam/config"
  #     ],
  #     "external_drivers" : null,
  #     "jsonid" : "vrpathreg",
  #     "log" :
  #     [
  #       "~/.local/share/Steam/logs"
  #     ],
  #     "runtime" :
  #     [
  #       "${pkgs.opencomposite}/lib/opencomposite"
  #     ],
  #     "version" : 1
  #   }
  # '';

  # This value determines the Home Manager release that your configuration is
  # compatible with. This helps avoid breakage when a new Home Manager release
  # introduces backwards incompatible changes.
  #
  # You should not change this value, even if you update Home Manager. If you do
  # want to update the value, then make sure to first check the Home Manager
  # release notes.
  home.stateVersion = "25.05"; # Please read the comment before changing.
}
