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
    virtualisation.virtualbox.host.enable = true;
    programs.virt-manager.enable = true;
    virtualisation.libvirtd.enable = true;
    virtualisation.spiceUSBRedirection.enable = true;

    users.groups.libvirtd.members = [ "${stellae.username}" ];
    users.extraGroups.vboxusers.members = [ "${stellae.username}" ];
  };
}
