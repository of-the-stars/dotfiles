{
  config,
  pkgs,
  lib,
  inputs,
  hostname,
  ...
}:
{
  imports = [
    # Paths to other modules.
    # Compose this module out of smaller ones.
    ./configuration.nix
    ./hardware-configuration.nix
  ];

}
