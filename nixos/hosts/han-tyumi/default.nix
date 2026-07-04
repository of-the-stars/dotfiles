{
  inputs,
  users,
  ...
}:
let
  hostname = "han-tyumi";
  stellae = users.stellae;
in
{
  specialArgs = {
    inherit
      hostname
      inputs
      stellae
      ;
  };
  modules = [
    ./configuration.nix
    ./hardware-configuration.nix
    # ({ pkgs, modulesPath, ... }: {
    #   imports = [ (modulesPath + "/installer/cd-dvd/installation-cd-minimal-new-kernel-no-zfs.nix") ];
    # })
    # Home manager
    inputs.home-manager.nixosModules.home-manager
    {
      home-manager.useGlobalPkgs = true;
      home-manager.useUserPackages = true;
      home-manager.backupFileExtension = "bak";
      home-manager.extraSpecialArgs = {
        inherit
          inputs
          stellae
          ;
      };
      home-manager.users.${stellae.username} = {
        imports = [
          stellae.home
        ];
        home.username = "${stellae.username}";
        home.homeDirectory = "/home/${stellae.username}";
      };
    }
    # Veila
    inputs.veila.nixosModules.default
    {
      programs.veila.enable = true;
    }
  ];
}
