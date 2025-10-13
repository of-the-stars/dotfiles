#!/usr/bin/env bash

# Based off of `0atman's` rebuild script, the script will let you configure NixOS, then rebuild and `git commit` for you

set -e

pushd $HOME/dotfiles/nixos/

    pushd $HOME/dotfiles/

    nvim
     
    # alejandra . &>/dev/null
    # The above command is good for formatting, but my neovim config already has configured to run on save :3

    git -P diff -U0 .

    popd

echo "NixOS Rebuilding..."

# Checks if the nvim directory was changed, then updates the flake so that the changes are reflected
if git diff -P --cached --name-only ./../.config/nvim/. | rg -q "."; then
    sudo nix flake update nvim
fi

if git diff -P --cached --name-only ./../.config/rmpc/. | rg -q "."; then
    sudo nix flake update rmpc
fi

if [[ -z "$1" ]]; then
    sudo nixos-rebuild switch --flake .#han-tyumi &>nixos-switch.log || (cat nixos-switch.log | rg --color=always error && false)
else
    sudo nixos-rebuild switch --flake .#"$1" &>nixos-switch.log || (cat nixos-switch.log | rg --color=always error && false)
fi

gen=$(nixos-rebuild list-generations | rg current)
git commit -a -m "$gen"

popd

hyprctl reload > /dev/null

paplay "$HOME/dotfiles/assets/User Initialisation Sequence Complete.ogg" &
