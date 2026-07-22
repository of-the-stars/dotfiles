{
  config,
  pkgs,
  lib,
  inputs,
  ...
}:
{
  imports = [
    ./terminal.nix
    ./media-tools.nix
    ./networking-tools.nix
    ./virtual-machines.nix
    ./system-security.nix
  ]
  # Desktop configs
  ++ [
    ./kde-config.nix
    ./niri-config.nix
  ];

  config = {
    modules.terminal.enable = lib.mkDefault true;
    modules.terminal.extra.enable = lib.mkDefault false;

    modules.media-tools.enable = lib.mkDefault true;
    modules.media-tools.extra.enable = lib.mkDefault false;

    modules.networking-tools.enable = lib.mkDefault true;
    modules.system-security.enable = lib.mkDefault true;
    modules.virtual-machines.enable = lib.mkDefault false;

    # Makes each host choose their desktop setup
    modules.kde-config.enable = lib.mkDefault false;
    modules.niri-config.enable = lib.mkDefault false;
  };
}
