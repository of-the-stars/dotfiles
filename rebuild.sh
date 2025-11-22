#!/usr/bin/env bash

# Based off of 0atman's rebuild script, the script will let you configure NixOS, then rebuild and `git commit` for you
# If you update something that's pinned with a flake, you need to add logic to update that flake 

set -o pipefail
set -e

pushd "$HOME"/dotfiles/nixos/

    pushd "$HOME"/dotfiles/

    nvim
     
    git -P diff -U0 .
    git add .

    popd

echo "NixOS Rebuilding..."

# Checks if the nvim directory was changed, then updates the flake so that the changes are reflected
if git diff -P --cached --name-only ./../.config/nvim/. | rg -q "."; then
    sudo nix flake update nvim
fi

if git diff -P --cached --name-only ./../.config/rmpc/. | rg -q "."; then
    sudo nix flake update rmpc
fi

# Allows reading the target system from script args
# TODO: Create a picker that lets you pick which system to rebuild into
if [[ -z "$1" ]]; then
    sudo nixos-rebuild switch --flake .#han-tyumi &> nixos-switch.log || (cat nixos-switch.log | rg --color=always error && false)
else
    sudo nixos-rebuild switch --flake .#"$1" &> nixos-switch.log || (cat nixos-switch.log | rg --color=always error && false)
fi

# Uncomment these two lines if you'd like to have the commit message just be the generation details
# gen=$(nixos-rebuild list-generations | rg current) 
# git commit -a -m "$gen"

# Uncomment this line if you'd like to write the commit message yourself
nixos-rebuild list-generations | rg current | git commit -aveF -

popd

# Reloads hyprland
hyprctl reload > /dev/null

pw-play "$HOME/dotfiles/assets/User Initialisation Sequence Complete.ogg" &
