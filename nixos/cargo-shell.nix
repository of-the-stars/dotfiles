# cargo-shell.nix
let
  pkgs = import <nixpkgs> {};
in
  pkgs.mkShell {
    packages = [];
    buildInputs = [
      pkgs.pkg-config
    ];
    shellHook = ''
      export PKG_CONFIG_PATH="${pkgs.openssl.dev}/lib/pkgconfig";
    '';
  }
