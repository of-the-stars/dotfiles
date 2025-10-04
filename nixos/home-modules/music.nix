{
  config,
  pkgs,
  lib,
  ...
}: {
  imports = [
    # Paths to other modules.
    # Compose this module out of smaller ones.
  ];

  options = {
    # Option declarations.
    # Declare what settings a user of this module can set.
    # Usually this includes a global "enable" option which defaults to false.
    music.enable =
      lib.mkEnableOption "Enables music";
  };

  config = lib.mkIf config.music.enable {
    # Option definitions.
    # Define what other settings, services and resources should be active.
    # Usually these depend on whether a user of this module chose to "enable" it
    # using the "option" above.
    # Options for modules imported in "imports" can be set here.

    programs.rmpc.enable = true;

    services.mpd-discord-rpc = {
      enable = true;
      settings = {
        id = 755546997242462280;
        hosts = ["localhost:6600"];

        format = {
          details = "$title";
          state = "$artist / $album / $disc";
          timestamp = "both";
          large_image = "notes";
          small_image = "notes";
          large_text = "";
          small_text = "";
          display_type = "name";
        };
      };
    };

    xdg.configFile = {
      "rmpc".source = ./../../.config/rmpc;
      "discord-rpc".source = ./../../.config/discord-rpc;
    };

    home.file = {
      ".lyrics".source = ./../../.lyrics;
    };

    # Enable the music player damon
    services.mpd = {
      enable = true;
      musicDirectory = "/home/internet_wizard/Music";
      playlistDirectory = "/home/internet_wizard/Music/.playlists";
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
  };
}
