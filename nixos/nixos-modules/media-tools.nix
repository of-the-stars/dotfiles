{
  config,
  pkgs,
  lib,
  ...
}:
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
      aseprite
      audacity
      droidcam
      dvgrab
      ffmpeg
      gimp
      handbrake
      inkscape
      kdePackages.k3b
      kdePackages.kdenlive
      kid3
      krita
      v4l-utils
      vcv-rack
      vlc
      yt-dlp
    ];
  };
}
