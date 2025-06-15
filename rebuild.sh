#!/usr/bin/env bash
set -e
pushd ~/dotfiles/nixos/
nvim configuration.nix
echo "NixOS Rebuilding..."
stow .
git diff -U1 configuration.nix
sudo nixos-rebuild switch &>nixos-switch.log || (cat nixos-switch.log | rg --color error && false)
gen=$(nixos-rebuild list-generations | rg current)
git commit -a -m "$gen"
popd
# alejandra . &>/dev/null
# git diff -U0 *.nix
# sudo nixos-rebuild switch &>nixos-switch.log || (
#  cat nixos-switch.log | grep --color error && false)
# gen=$(nixos-rebuild list-generations | grep current)
# 

