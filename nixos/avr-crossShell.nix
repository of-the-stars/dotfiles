let
  pkgs = import <nixpkgs> {};
in
  pkgs.pkgsCross.avr.mkShell {}
