{
  inputs,
  users,
  ...
}:
let
  inherit (users) syren;
in
{
  specialArgs = {
    inherit
      inputs
      syren
      ;
  };
  modules = [
    # Paths to other modules.
    # Compose this module out of smaller ones.
    ./configuration.nix
    ./hardware-configuration.nix
  ];
}
