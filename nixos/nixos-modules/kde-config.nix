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
    kde-config.enable = lib.mkEnableOption "Enables KDE";
  };

  config = lib.mkIf config.kde-config.enable {
    # Option definitions.
    # Define what other settings, services and resources should be active.
    # Usually these depend on whether a user of this module chose to "enable" it
    # using the "option" above.
    # Options for modules imported in "imports" can be set here.

    # Enable the X11 windowing system.
    # You can disable this if you're only using the Wayland session.
    services.xserver = {
      enable = true;
      # Configure keymap in X11
      xkb = {
        layout = "us";
        variant = "";
      };

      # videoDrivers = [ "modesetting" ];
    };

    # Enable KDE
    services.displayManager = {
      sddm = {
        enable = true;
        # wayland.enable = true;
      };
      autoLogin.enable = true;
      # defaultSession = "plasmax11";
    };

    services.desktopManager.plasma6.enable = true;

    environment.plasma6.excludePackages = with pkgs.kdePackages; [ ];

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
      # nerd-fonts.roboto-mono
    ];

    environment.systemPackages = with pkgs; [
    ];

    services.flatpak.enable = true;
    systemd.services.flatpak-repo = {
      wantedBy = [ "multi-user.target" ];
      path = [ pkgs.flatpak ];
      # script = ''
      #   flatpak remote-add --if-not-exists flathub https://flathub.org/repo/flathub.flatpakrepo
      # '';
    };
  };
}
