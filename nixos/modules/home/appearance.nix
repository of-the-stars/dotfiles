{
  config,
  pkgs,
  lib,
  ...
}:
{
  options = {
    appearance.enable = lib.mkEnableOption "Enables appearance stuff";
  };

  config = lib.mkIf config.appearance.enable {
    dconf.settings."org/gnome/desktop/interface" = {
      color-scheme = "prefer-dark";
      gtk-theme = "Adwaita-dark";
    };

    qt = {
      enable = true;
      platformTheme.name = "kde";
      style.name = "breeze";
    };

    gtk = {
      colorScheme = "dark";
      font = {
        name = "RobotoMono Nerd Font";
        package = pkgs.nerd-fonts.roboto-mono;
      };
    };

    home = {
      file.".config/kdeglobals" = {
        text = ''
          ${builtins.readFile "${pkgs.kdePackages.breeze}/share/color-schemes/BreezeDark.colors"}
        '';
      };

      pointerCursor = {
        x11.enable = true;
        gtk.enable = true;
        package = pkgs.catppuccin-cursors.mochaBlue;
        name = "Catppuccin-Mocha-Blue-Cursors";
        size = 48;
      };
    };
  };
}
