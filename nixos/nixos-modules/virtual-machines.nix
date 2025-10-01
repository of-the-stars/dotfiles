{ config, pkgs, lib, ...}:
{
  imports = [
    # Paths to other modules.
    # Compose this module out of smaller ones.
  ];

  options = {
    # Option declarations.
    # Declare what settings a user of this module can set.
    # Usually this includes a global "enable" option which defaults to false.
    virtual-machines.enable =
      lib.mkEnableOption "Enable virtual machine tools";
  };

  config = lib.mkIf config.virtual-machines.enable {
    # Option definitions.
    # Define what other settings, services and resources should be active.
    # Usually these depend on whether a user of this module chose to "enable" it
    # using the "option" above. 
    # Options for modules imported in "imports" can be set here.

    virtualisation.virtualbox.host.enable = true;
    users.extraGroups.vboxusers.members = ["internet_wizard"];

    programs.virt-manager.enable = true;
    users.groups.libvirtd.members = ["internet_wizard"];
    virtualisation.libvirtd.enable = true;
    virtualisation.spiceUSBRedirection.enable = true;
  };
}
