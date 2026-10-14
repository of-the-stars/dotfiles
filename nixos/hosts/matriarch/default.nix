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
    ./configuration.nix
    ./hardware-configuration.nix
  ];
}
