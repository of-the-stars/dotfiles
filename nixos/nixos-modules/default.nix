{
  config,
  pkgs,
  lib,
  inputs,
  ...
}:
{
  imports = [
    # Paths to other modules.
    # Compose this module out of smaller ones.
    ./terminal.nix
    ./hyprland-config.nix
    ./media-tools.nix
    ./networking-tools.nix
    ./virtual-machines.nix
    ./hardware-security.nix
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

    terminal.enable = lib.mkDefault true;
    hyprland-config.enable = lib.mkDefault true;
    media-tools.enable = lib.mkDefault true;
    networking-tools.enable = lib.mkDefault true;
    hardware-security.enable = lib.mkDefault true;
    virtual-machines.enable = lib.mkDefault false;
  };
}
