{
  config,
  pkgs,
  lib,
  inputs,
  ...
}:
let
  init-desktop = pkgs.writeShellApplication {
    name = "init-desktop";
    text = ''
      niri-session
    '';
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

    modules.niri-config.enable = lib.mkEnableOption "Enables the niri window manager";
  };

  config = {
    # Option definitions.
    # Define what other settings, services and resources should be active.
    # Usually these depend on whether a user of this module chose to "enable" it
    # using the "option" above.
    # Options for modules imported in "imports" can be set here.

    programs.niri.enable = true;

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

    environment.systemPackages = [
      init-desktop
    ]
    ++ (with pkgs; [
      brightnessctl
      dunst # Notification daemon
      pavucontrol # Pipewire sound control
      rofi # Pop up menus
      waybar # Status bar
      wl-clipboard # Manage clipboard on wayland
    ]);
  };
}
