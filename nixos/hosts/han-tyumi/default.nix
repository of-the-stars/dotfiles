{
  inputs,
  users,
  ...
}:
let
  stellae = users.stellae;
in
{
  specialArgs = {
    inherit
      inputs
      stellae
      ;
  };
  modules = [
    # ({ pkgs, modulesPath, ... }: {
    #   imports = [ (modulesPath + "/installer/cd-dvd/iso-image.nix") ]; TODO: Fix the module so that it doesn't send me to emergency mode cuz it can't mount a partition
    # })
    ./configuration.nix
    ./hardware-configuration.nix
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
        inherit (stellae) username;
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
