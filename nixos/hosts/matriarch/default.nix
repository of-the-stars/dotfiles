{
  config,
  pkgs,
  lib,
  inputs,
  users,
  ...
}:
let
  hostname = "matriarch";
  syren = users.syren // {
    username = "syren";
  };
in
{
  imports = [
    # Paths to other modules.
    # Compose this module out of smaller ones.
    ./configuration.nix
    ./hardware-configuration.nix
  ];
}
