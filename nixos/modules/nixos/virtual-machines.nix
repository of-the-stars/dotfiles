{
  config,
  pkgs,
  lib,
  stellae,
  ...
}:
{
  options = {
    modules.virtual-machines.enable = lib.mkEnableOption "Enable virtual machine tools";
  };

  config = lib.mkIf config.modules.virtual-machines.enable {
    virtualisation = {
      virtualbox.host.enable = true;
      libvirtd.enable = true;
      spiceUSBRedirection.enable = true;
    };

    programs.virt-manager.enable = true;

    users = {
      groups.libvirtd.members = [ "${stellae.username}" ];
      extraGroups.vboxusers.members = [ "${stellae.username}" ];
    };
  };
}
