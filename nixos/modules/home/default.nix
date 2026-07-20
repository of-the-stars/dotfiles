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
    # ./home-security.nix
    ./music.nix
    ./terminal.nix
  ];

  config = {
    # home-security.enable = lib.mkDefault false;
    music.enable = pkgs.lib.mkDefault true;
    terminal.enable = pkgs.lib.mkDefault true;
  };
}
