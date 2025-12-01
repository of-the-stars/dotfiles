{
  description = "A flake wrapping rmpc with cava";

  inputs = {
    nixpkgs.url = "github:nixos/nixpkgs?ref=nixos-unstable";
  };

  outputs =
    {
      self,
      nixpkgs,
    }:
    let
      system = "x86_64-linux";
      pkgs = nixpkgs.legacyPackages.${system};
    in
    {
      packages.${system} = {
        rmpc = pkgs.rmpc.overrideAttrs (
          finalAttrs: prevAttrs: {
            nativeBuildInputs = [
              pkgs.makeWrapper
            ];

            postFixup = ''
              wrapProgram $out/bin/rmpc \
              --prefix PATH ":" ${nixpkgs.lib.makeBinPath [ pkgs.cava ]}
            '';
          }
        );
      };

      # packages.${system}.default = self.packages.${system}.rmpc;
    };
}
