#!/usr/bin/env bash

FILE=$(fd -a --type=d | rofi -i -dmenu -p "Choose Folder") 
echo "$FILE"
FILE+=$(eza -1 -f --sort=accessed --no-quotes "$FILE" | rofi -i -dmenu -p "Choose File")
echo "$FILE"
handlr open "${FILE}"
