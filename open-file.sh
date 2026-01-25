#!/usr/bin/env bash

FILE=$(fd -a --type=d | rofi -i -dmenu -p "Choose Folder") 
echo "$FILE"
z "$FILE"
FILE+=$(eza -1 -f --sort=accessed --no-quotes | rofi -i -dmenu -p "Choose File")
echo "$FILE"
handlr open "${FILE}"
