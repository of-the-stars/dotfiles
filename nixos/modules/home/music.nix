{
  config,
  pkgs,
  lib,
  inputs,
  username,
  ...
}:
let
  pkgsUnstable = inputs.nixpkgs-unstable.legacyPackages."${pkgs.stdenv.system}";
in
{
  options = {
    music.enable = lib.mkEnableOption "Enables music";
  };

  config = lib.mkIf config.music.enable {
    programs.rmpc = {
      enable = true;
      package = pkgsUnstable.rmpc.overrideAttrs {
        buildInputs = with pkgsUnstable; [
          cava
          yt-dlp
        ];
      };
    };

    home.packages = with pkgs; [
      mpd-discord-rpc
    ];

    services = {
      # ===================================================================
      # ========== Entire section ikely to be replaced by `rmpcd` =========
      # ===================================================================
      mpd-mpris.enable = true;

      mpdscribble = {
        enable = true;
        endpoints."last.fm" = {
          username = "internet_wizard";
          passwordFile = "home/${username}/.secrets/lastfm_password";
        };
        journalInterval = 10;
      };
      # ===================================================================

      mpd-discord-rpc = {
        enable = true;
      };

      # Enable the music player damon
      mpd = {
        enable = true;
        musicDirectory = "/home/${username}/Music";
        playlistDirectory = "/home/${username}/Music/.playlists";
        extraConfig = ''
          audio_output {
            type "pipewire"
            name "my pipewire"
            mixer_device "default"
            mixer_control "PCM"
          }
        '';

        # settings = {
        #   audio_output = [
        #     {
        #       type = "pipewire";
        #       name = "my pipewire";
        #       mixer_device = "default";
        #       mixer_control = "PCM";
        #     }
        #   ];
        # };

        network.port = 6600;

        # Optional:
        network.listenAddress = "any"; # if you want to allow non-localhost connections
        # network.startWhenNeeded = true; # systemd feature: only start MPD service upon connection to its socket
      };
    };

    programs = {
      cava = {
        enable = true;
        settings = {
          general.framerate = 60;
          input.method = "pipewire";
          input.source = "auto";
          smoothing.noise_reduction = 88;
        };
      };

      mpv.enable = true;
    };
  };
}
