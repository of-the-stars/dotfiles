#!/usr/bin/env bash
# This assumes you're using Dunst as your notification daemon

echo "true false" | rofi -sep ' ' -dmenu -p "Set Do Not Disturb On?" | xargs dunstctl set-paused 
