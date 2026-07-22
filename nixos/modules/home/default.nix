{
  config,
  pkgs,
  lib,
  inputs,
  username,
  ...
}:
{
  imports = [
    ./music.nix
    ./terminal.nix
  ];

  config = {
    music.enable = pkgs.lib.mkDefault true;
    terminal.enable = pkgs.lib.mkDefault true;
  };
}
