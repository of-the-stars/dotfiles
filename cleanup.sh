#!/usr/bin/env bash

# Stolen from the 11th nix pill by Lethalman

nix-channel --update
nix-env -u --always
rm /nix/var/nix/gcroots/auto/*
sudo nix-collect-garbage -d
nixos-rebuild switch
