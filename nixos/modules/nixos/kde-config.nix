{
  config,
  pkgs,
  lib,
  ...
}:
{
  imports = [
  ];

  options = {
    modules.kde-config.enable = lib.mkEnableOption "Enables KDE";
  };

  config = lib.mkIf config.modules.kde-config.enable (
    let
      discoverWrapped = pkgs.symlinkJoin {
        name = "discoverFlatpakBackend";
        paths = [
          pkgs.kdePackages.discover
        ];
        buildInputs = [ pkgs.makeWrapper ];
        postBuild = ''
          wrapProgram $out/bin/plasma-discover --add-flags "--backends flatpak"
        '';
      };
    in
    {
      # Enable the X11 windowing system.
      # You can disable this if you're only using the Wayland session.
      services.xserver.enable = true;

      # Enable the KDE Plasma Desktop Environment.
      services.displayManager.sddm.enable = true;
      services.desktopManager.plasma6.enable = true;

      # Configure keymap in X11
      services.xserver.xkb = {
        layout = "us";
        variant = "";
      };

      # environment.sessionVariables = {
      #   # If your cursor becomes invisible
      #   # WLR_NO_HARDWARE_CURSORS = "1";
      #   # Hint electron apps to use wayland
      #   ELECTRON_OZONE_PLATFORM_HINT = "auto";
      #   WAYLAND_DISPLAY = "1";
      #   NIXOS_OZONE_WL = 1;
      # };

      environment.systemPackages = with pkgs; [
        discoverWrapped
      ];

      services.flatpak.enable = true;
      # systemd.services.flatpak-repo = {
      #   wantedBy = [ "multi-user.target" ];
      #   path = [ pkgs.flatpak ];
      #   # script = ''
      #   #   flatpak remote-add --if-not-exists flathub https://flathub.org/repo/flathub.flatpakrepo
      #   # '';
      # };
    }
  );
}
