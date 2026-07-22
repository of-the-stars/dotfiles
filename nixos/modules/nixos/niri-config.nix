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
  options = {
    modules.niri-config.enable = lib.mkEnableOption "Enables the niri window manager";
  };

  config = {
    programs.niri.enable = true;

    services.dunst = {
      enable = true;
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

    environment.systemPackages =
      (with pkgs; [
        brightnessctl
        kitty # Terminal Emulator
        libnotify # Send desktop notifications
        networkmanagerapplet
        pavucontrol # Pipewire sound control
        pipewire
        playerctl
        rofi # Pop up menus
        waybar # Status bar
        wl-clipboard # Manage clipboard on wayland
        xwayland-satellite # Run X applications
      ])
      ++ (with pkgsUnstable; [
        wpaperd # Wallpaper daemon written in rust
      ]);
  };
}
