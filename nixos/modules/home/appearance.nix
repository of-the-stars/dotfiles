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
    dconf.settings."org/gnome/desktop/interface".color-scheme = "prefer-dark";
    dconf.settings."org/gnome/desktop/interface".gtk-theme = "Adwaita-dark";
    qt = {
      enable = true;
      platformTheme.name = "kde";
      style.name = "breeze";
    };
    home.file.".config/kdeglobals" = {
      text = ''
        ${builtins.readFile "${pkgs.kdePackages.breeze}/share/color-schemes/BreezeDark.colors"}
      '';
    };
  };
}
