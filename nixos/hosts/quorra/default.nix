# This is the configuration import for my custom NixOS installer live ISO
# It can be built with either
# ```sh
#   nix build \
#     .#nixosConfigurations.quorra.config.system.build.isoImage
# ```
# OR
# ```sh
#   nix run nixpkgs#nixos-generators -- \
#     --format iso --flake ./path/to/flake#quorra -o resultIso
# ```

{
  inputs,
  users,
  ...
}:
let
  inherit (users) nixos;

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
      nixos
      ;
  };

  modules = [
    ./configuration.nix
    inputs.home-manager.nixosModules.home-manager
    (makeHomeManagerConfig nixos)
  ];
}
