#!/usr/bin/env bash

# Stolen from the 11th nix pill by Lethalman

nix-channel --update
nix-env -u --always
rm /nix/var/nix/gcroots/auto/*
nix-collect-garbage -d
