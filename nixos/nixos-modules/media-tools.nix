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
  imports = [
    # Paths to other modules.
    # Compose this module out of smaller ones.
  ];

  options = {
    # Option declarations.
    # Declare what settings a user of this module can set.
    # Usually this includes a global "enable" option which defaults to false.
    media-tools.enable = lib.mkEnableOption "Enable media tools";
  };

  config = lib.mkIf config.media-tools.enable {
    # Option definitions.
    # Define what other settings, services and resources should be active.
    # Usually these depend on whether a user of this module chose to "enable" it
    # using the "option" above.
    # Options for modules imported in "imports" can be set here.

    programs.obs-studio = {
      enable = true;
      enableVirtualCamera = true;

      plugins = with pkgs.obs-studio-plugins; [
        droidcam-obs
        obs-backgroundremoval
        obs-gstreamer
        obs-pipewire-audio-capture
        obs-vaapi
        obs-vkcapture
        wlrobs
      ];
    };

    environment.systemPackages = with pkgs; [
      pkgsUnstable.kdePackages.k3b # CD and DVD manager

      aseprite # Sprite drawing program
      audacity # Audio editor
      cdrdao
      cdrtools
      droidcam
      dvgrab # DV Camcorder Video Capture
      ffmpeg # Video format transcription
      gimp # Image editor
      handbrake
      inkscape
      kdePackages.kdenlive # Video editor
      kid3 # Audio tagger
      krita # Drawing program
      vcv-rack # Modular synthesizers
      vlc # Media player
      yt-dlp # YouTube downloader
    ];

    security.wrappers = {
      cdrdao = {
        setuid = true;
        owner = "root";
        group = "cdrom";
        permissions = "u+wrx,g+x";
        source = "${pkgs.cdrdao}/bin/cdrdao";
      };
      cdrecord = {
        setuid = true;
        owner = "root";
        group = "cdrom";
        permissions = "u+wrx,g+x";
        source = "${pkgs.cdrtools}/bin/cdrecord";
      };
    };
  };
}
