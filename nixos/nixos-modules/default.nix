{
  config,
  pkgs,
  lib,
  inputs,
  ...
}:
{
  # Paths to other modules.
  # Compose this module out of smaller ones.
  imports = [
    ./terminal.nix
    ./media-tools.nix
    ./networking-tools.nix
    ./virtual-machines.nix
    ./system-security.nix
  ]
  # Desktop configs
  ++ [
    ./hyprland-config.nix
    ./kde-config.nix
    ./niri-config.nix
  ];

  options = {
    # Option declarations.
    # Declare what settings a user of this module can set.
    # Usually this includes a global "enable" option which defaults to false.
  };

  config = {
    # Option definitions.
    # Define what other settings, services and resources should be active.
    # Usually these depend on whether a user of this module chose to "enable" it
    # using the "option" above.
    # Options for modules imported in "imports" can be set here.

    modules.terminal.enable = lib.mkDefault true;
    modules.terminal.extra.enable = lib.mkDefault false;

    modules.media-tools.enable = lib.mkDefault true;
    modules.media-tools.extra.enable = lib.mkDefault false;

    modules.networking-tools.enable = lib.mkDefault true;
    modules.system-security.enable = lib.mkDefault true;
    modules.virtual-machines.enable = lib.mkDefault false;

    # Makes each host choose their desktop setup
    modules.hyprland-config.enable = lib.mkDefault false;
    modules.kde-config.enable = lib.mkDefault false;
    modules.niri-config.enable = lib.mkDefault false;
  };
}
