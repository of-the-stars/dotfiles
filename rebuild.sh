#!/usr/bin/env bash

# Based off of `0atman's` rebuild script, the script will let you configure NixOS, then rebuild and `git commit` for you

set -e
pushd ~/dotfiles/nixos/
nvim configuration.nix
# alejandra . &>/dev/null
git diff -U0 *.nix
echo "NixOS Rebuilding..."

# Checks if the nvim directory was changed, then updates the flake so that the changes are reflected
#if git diff --cached --name-only --relative=./../.config/nvim/ | rg -q "."; then
    sudo nix flake update nvim
#fi

sudo nixos-rebuild switch --flake . &>nixos-switch.log || (cat nixos-switch.log | rg --color=always error && false)
gen=$(nixos-rebuild list-generations | rg current)
git commit -a -m "$gen"
popd
