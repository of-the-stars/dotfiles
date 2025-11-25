#!/usr/bin/env bash

# Based off of 0atman's rebuild script, the script will let you configure NixOS, then rebuild and `git commit` for you
# If you update something that's pinned with a flake, you need to add logic to update that flake 

set -o pipefail
set -e

pushd "$HOME"/dotfiles/nixos/

    pushd "$HOME"/dotfiles/

    nvim
     
    git -P diff -U0 .
    git add --all

    popd

# Checks if the nvim directory was changed, then updates the flake so that the changes are reflected
if git diff -P --cached --name-only ./../.config/nvim/. | rg -q "."; then
    sudo nix flake update nvim
fi

# Opens up a menu with each system that can be built and switches to that system
system="$(nix flake show . --json | jq -r ".nixosConfigurations | keys[]" | fzf \
    --color='border:blue' \
    --color='label:white:bold' \
    --color='list-bg:-1' \
    --color='gutter:-1' \
    --color='hl:blue:bold' \
    --color='hl+:green:bold' \
    --color='fg+:white' \
    --color='info:white' \
    --color='pointer:green' \
    --tac \
    --border \
    --margin=10% \
    --padding 5,5 \
    --border-label ' Choose System Which To Rebuild ' \
    --input-label ' Input ' \
    )"
echo "NixOS Rebuilding..."
(sudo nixos-rebuild switch --show-trace --flake .#"$system" | tee nixos-switch.log) || (cat nixos-switch.log | rg --color=always error && false)

pw-play "$HOME/dotfiles/assets/User Initialisation Sequence Complete.ogg" &

# Uncomment these two lines if you'd like to have the commit message just be the generation details
# gen=$(nixos-rebuild list-generations | rg current) 
# git commit -a -m "$gen"

# Uncomment this line if you'd like to write the commit message yourself
nixos-rebuild list-generations | rg current | git commit -aveF -

popd

# Reloads hyprland
hyprctl reload > /dev/null
