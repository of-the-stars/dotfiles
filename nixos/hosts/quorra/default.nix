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
in
{
  specialArgs = {
    inherit
      inputs
      nixos
      ;
  };

  modules =
    # Modules from files
    [
      ./configuration.nix
    ]
    # Modules from flake inputs
    ++ [
      # Home manager
      inputs.home-manager.nixosModules.home-manager
      (makeHomeManagerConfig nixos)
    ];
}
