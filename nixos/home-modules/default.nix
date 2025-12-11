{
  config,
  pkgs,
  lib,
  username,
  ...
}:
{
  imports = [
    # Paths to other modules.
    # Compose this module out of smaller ones.
    ./music.nix
    ./terminal.nix
    ./home-security.nix
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

    music.enable = lib.mkDefault true;
    terminal.enable = lib.mkDefault true;
    home-security.enable = lib.mkDefault false;
  };
}
