#!/usr/bin/env bash

# Stolen and modified from the 11th nix pill by Lethalman

# sudo rm /nix/var/nix/gcroots/auto/*
SCRIPT_DIRECTORY="$(dirname $(realpath "$0"))"

sudo nix-collect-garbage -d
./"$SCRIPT_DIRECTORY"/rebuild.sh
