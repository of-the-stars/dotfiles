{ config, pkgs, ... }:
{
  home.username = "internet_wizard";
  home.homeDirectory = "/home/internet_wizard";

  home.packages = with pkgs; [ ];

  xdg.configFile = {
    "hypr".source = ./../.config/hypr;
    "nvim".source = ./../.config/nvim;
    "rmpc".source = ./../.config/rmpc;
    # "dunst".source = ./../.config/dunst;
    # "halloy".source = ./../.config/halloy;
    "kitty".source = ./../.config/kitty;
    # "ncspot".source = ./../.config/ncspot;
    # "tiny".source = ./../.config/tiny;
    "waybar".source = ./../.config/waybar;
    "wofi".source = ./../.config/wofi;
  };

  home.file = {
    ".lyrics".source = ./../.lyrics;
    ".secrets".source = ./../.secrets;
    ".gitconfig".source = ./../.gitconfig;
    ".bashrc".source = ./../.bashrc;
    ".stow-global-ignora".source = ./../.stow-global-ignore;

    "cleanup.sh".source = ./../cleanup.sh;
    "rebuild.sh".source = ./../rebuild.sh;
  };

  # This value determines the Home Manager release that your configuration is 
  # compatible with. This helps avoid breakage when a new Home Manager release 
  # introduces backwards incompatible changes. 
  #
  # You should not change this value, even if you update Home Manager. If you do 
  # want to update the value, then make sure to first check the Home Manager 
  # release notes. 
  home.stateVersion = "25.05"; # Please read the comment before changing. 

  # Enable the music player damon
  services.mpd = {
    enable = true;
    musicDirectory = "/home/internet_wizard/Music";
      extraConfig = ''
        audio_output {
          type "pipewire"
          name "my pipewire"
          mixer_device "default"
          mixer_control "PCM"
        }
      '';

    network.port = 6600;
  
    # Optional:
    network.listenAddress = "any"; # if you want to allow non-localhost connections
    # network.startWhenNeeded = true; # systemd feature: only start MPD service upon connection to its socket
    # user = "internet_wizard";
  };

  services.mpdscribble = {
    enable = true;
    endpoints."last.fm" = {
      username = "internet_wizard";
      passwordFile = "/home/internet_wizard/.secrets/lastfm_password";
    };
    journalInterval = 10;
  }; 

  programs.cava = {
    enable = true;
    settings = {
      general.framerate = 60;
      input.method = "pipewire";
      input.source = "auto";
      smoothing.noise_reduction = 88;
    };
  };
}
