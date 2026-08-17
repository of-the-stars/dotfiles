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

    services.mpd-mpris.enable = true;

    services.mpd-discord-rpc = {
      enable = true;
      # settings = {
      #   id = 677226551607033903;
      #   hosts = [ "localhost:6600" ];
      #
      #   format = {
      #     details = "$title";
      #     state = "$artist / $album / $disc";
      #     timestamp = "both";
      #     large_image = "notes";
      #     small_image = "notes";
      #     large_text = "";
      #     small_text = "";
      #     display_type = "name";
      #   };
      # };
    };

    # Enable the music player damon
    services.mpd = {
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

    services.mpdscribble = {
      enable = true;
      endpoints."last.fm" = {
        username = "internet_wizard";
        passwordFile = "home/${username}/.secrets/lastfm_password";
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

    programs.mpv = {
      enable = true;

      config = {
        profile = "high-quality";
        ytdl-format = "bestvideo+bestaudio";
        # cache-default = 4000000;
      };
    };
  };
}
