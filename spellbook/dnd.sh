#!/usr/bin/env bash
# This assumes you're using Dunst as your notification daemon

echo "true false" | rofi -sep ' ' -dmenu -p "Switch Do Not Disturb on or off" | xargs dunstctl set-paused 
