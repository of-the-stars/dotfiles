#!/usr/bin/env bash

# Based off of `0atman's` rebuild script, the script will let you configure NixOS, then rebuild and `git commit` for you

set -e
pushd ~/dotfiles/nixos/
nvim configuration.nix
# alejandra . &>/dev/null
git diff -U0 *.nix
echo "NixOS Rebuilding..."
sudo nixos-rebuild switch --flake . &>nixos-switch.log || (cat nixos-switch.log | rg --color=always error && false)

gen=$(nixos-rebuild list-generations | rg current)
fastfetch 
git commit -a -m "$gen"
popd
