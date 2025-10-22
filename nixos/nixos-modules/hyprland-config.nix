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
    hyprland-config.enable =
      lib.mkEnableOption "Enables the hyprland window manager";
  };

  config = lib.mkIf config.hyprland-config.enable {
    # Option definitions.
    # Define what other settings, services and resources should be active.
    # Usually these depend on whether a user of this module chose to "enable" it
    # using the "option" above.
    # Options for modules imported in "imports" can be set here.

    # Enable the Hyprland window manager
    programs.hyprland = {
      enable = true;
      xwayland.enable = true;
      withUWSM = true;
    };

    environment.sessionVariables = {
      # If your cursor becomes invisible
      # WLR_NO_HARDWARE_CURSORS = "1";
      # Hint electron apps to use wayland
      ELECTRON_OZONE_PLATFORM_HINT = "auto";
      WAYLAND_DISPLAY = "1";
      NIXOS_OZONE_WL = 1;
    };

    # Fonts
    fonts.packages = with pkgs; [
      nerd-fonts.roboto-mono
    ];

    environment.systemPackages = with pkgs; [
      dunst
      grim
      hyprlock
      hyprpaper
      kdePackages.dolphin
      networkmanagerapplet
      playerctl
      slurp
      waybar
      wev
      wireplumber
      wl-clipboard
      wofi
      rofi
      rofi-obsidian
      bluez
      brightnessctl
      libnotify
      pipewire
    ];
  };
}
