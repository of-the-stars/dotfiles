#!/usr/bin/env bash

notify-send -i "$2" "New wallpaper set"

rm ~/dotfiles/assets/current-wallpaper
ln -s "$(wpaperctl get eDP-1)" ~/dotfiles/assets/current-wallpaper
