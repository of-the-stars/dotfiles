{
  inputs,
  users,
  ...
}:
let
  inherit (users) stellae;

  makeHomeManagerConfig =
    user:
    let
      inherit (user) username;
    in
    {
      home-manager.useGlobalPkgs = true;
      home-manager.useUserPackages = true;
      home-manager.backupFileExtension = "bak";
      home-manager.extraSpecialArgs = {
        inherit
          inputs
          user
          username
          ;
      };
      home-manager.users.${username} = {
        imports = [
          user.home
        ];
        home.username = "${username}";
        home.homeDirectory = "/home/${username}";
      };
    };

  veilaConfig = {
    programs.veila.enable = true;
  };
in
{
  specialArgs = {
    inherit
      inputs
      stellae
      ;
  };

  modules =
    # Modules from files
    [
      ./configuration.nix
      ./hardware-configuration.nix
    ]
    # Modules from flake inputs
    ++ [
      # Home manager
      inputs.home-manager.nixosModules.home-manager
      (makeHomeManagerConfig stellae)
      # Veila
      inputs.veila.nixosModules.default
      veilaConfig
    ];
}
