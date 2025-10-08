{
  description = "A very basic flake";

  inputs = {
    nixpkgs.url = "github:nixos/nixpkgs?ref=nixos-unstable";
  };

  outputs = {
    self,
    nixpkgs,
  }: let
    systems = ["x86_64-linux" "aarch64-linux"]; # Define target systems
    forAllSystems = f: nixpkgs.lib.genAttrs systems (system: f nixpkgs.legacyPackages.${system});
  in {
    packages = forAllSystems (pkgs: {
      rmpc = pkgs.stdenv.mkDerivation {
        pname = "rmpc";
        version = "1.0";

        src = ./.; # Or fetch your existing source from a URL/git repo

        # Specify build inputs (dependencies needed during compilation/installation)
        buildInputs = with pkgs; [
          # Add any build-time dependencies here (e.g., compilers, build tools)
        ];

        # Specify runtime dependencies
        nativeBuildInputs = with pkgs; [
          # Add any tools needed during the build process itself
        ];

        # Define the build phase (how to build/install your software)
        # This will depend on your existing package's build system
        installPhase = ''
          mkdir -p $out/bin
          cp -r ${pkgs.rmpc} $out/bin/
        '';

        # Define runtime dependencies that need to be in the final package environment
        runtimeDependencies = with pkgs; [
          # Add any libraries or executables needed by your package at runtime
          # For example: libGL, openssl, python3, etc.
          cava
        ];
      };
    });
  };
}
