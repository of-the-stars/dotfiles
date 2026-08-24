{
  inputs,
  users,
  ...
}:
let
  stellae = users.stellae;

  makeHomeManagerConfig = user: {
    home-manager.useGlobalPkgs = true;
    home-manager.useUserPackages = true;
    home-manager.backupFileExtension = "bak";
    home-manager.extraSpecialArgs = {
      inherit
        inputs
        user
        ;
      inherit (user) username;
    };
    home-manager.users.${user.username} = {
      imports = [
        user.home
      ];
      home.username = "${user.username}";
      home.homeDirectory = "/home/${user.username}";
    };
  };
in
{
  specialArgs = {
    inherit
      inputs
      stellae
      ;
  };

  # ({ pkgs, modulesPath, ... }: {
  #   imports = [ (modulesPath + "/installer/cd-dvd/iso-image.nix") ]; # TODO: Fix the module so that it doesn't send me to emergency mode
  # })
  modules = [
    ./configuration.nix
    ./hardware-configuration.nix
    # Home manager
    inputs.home-manager.nixosModules.home-manager
    (makeHomeManagerConfig stellae)
    # Veila
    inputs.veila.nixosModules.default
    {
      programs.veila.enable = true;
    }
  ];
}
