{
  config,
  pkgs,
  lib,
  ...
}:
{
  options = {
    modules.networking-tools.enable = lib.mkEnableOption "Enables networking tools";
  };

  config = lib.mkIf config.modules.networking-tools.enable {
    environment.systemPackages = with pkgs; [
      traceroute
      wireshark
      proton-vpn
      qbittorrent
      nmap
    ];
  };
}
