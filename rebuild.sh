#!/usr/bin/env bash

# Based off of `0atman's` rebuild script, the script will let you configure NixOS, then rebuild and `git commit` for you

set -e
pushd ~/dotfiles/nixos/
nvim configuration.nix
# alejandra . &>/dev/null
git diff -U0 configuration.nix
echo "\nNixOS Rebuilding...\n"
sudo nixos-rebuild switch &>nixos-switch.log || (cat nixos-switch.log | rg --color error && false)
gen=$(nixos-rebuild list-generations | rg current)
git commit -a -m "$gen"
fastfetch &>./../fastfetch-latest
popd

