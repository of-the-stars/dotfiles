#!/usr/bin/env bash
set -e
pushd ~/dotfiles/nixos/
nvim configuration.nix
# alejandra . &>/dev/null
git diff -U0 configuration.nix
sudo nixos-rebuild switch &>nixos-switch.log || (cat nixos-switch.log | rg --color error && false)
echo "NixOS Rebuilding..."
gen=$(nixos-rebuild list-generations | rg current)
git commit -a -m "$gen"
popd

