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
    ./appearance.nix
    ./music.nix
    ./terminal.nix
  ];

  config = {
    appearance.enable = pkgs.lib.mkDefault true;
    music.enable = pkgs.lib.mkDefault true;
    terminal.enable = pkgs.lib.mkDefault true;
  };
}
