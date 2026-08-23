#!/usr/bin/env nix-shell
#! nix-shell -i bash -p fzf git ripgrep

# This script is supposed to help you bootstrap a NixOS configuration on a fresh minimal NixOS install

set -o pipefail
set -e

pushd "$HOME"/dotfiles/nixos/

    # Opens up a menu with each system that can be built and switches to that system
    system="$(find "$HOME"/dotfiles/nixos/hosts -maxdepth 1 -mindepth 1 -type d -printf '%f\n' | fzf \
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
        --border-label ' Choose System Which To Bootstrap' \
        --input-label ' Input ' \
        # || true
        )"

    $EDITOR

    cp /etc/nixos/hardware-configuration.nix ./hosts/"$system"/hardware-configuration.nix

    git -P diff -U0 .
    git add --all

    echo "Bootstrapping system..."

    (sudo nixos-rebuild switch --show-trace --flake .\#"$system" | tee nixos-switch.log) || (cat nixos-switch.log | rg --color=always error && false)
popd
