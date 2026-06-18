{
  inputs,
  users,
  ...
}:
let
  hostname = "han-tyumi";
  stellae = users.stellae // {
    username = "internet_wizard";
  };
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
          ../../users/stellae/home.nix
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
