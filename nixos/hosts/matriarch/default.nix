{
  inputs,
  users,
  ...
}:
let
  hostname = "matriarch";
  syren = users.syren // {
    username = "syren";
  };
in
{
  specialArgs = {
    inherit
      hostname
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
