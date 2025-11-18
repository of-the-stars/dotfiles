#!/usr/bin/env bash

# Stolen and modified from the 11th nix pill by Lethalman

sudo rm /nix/var/nix/gcroots/auto/*
sudo nix-collect-garbage -d
./rebuild.sh
