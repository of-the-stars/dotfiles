#!/usr/bin/env bash

FILE=$(eza -1 --sort=accessed ---no-quotes -absolute=follow -R -D | rofi -i -dmenu -p "Choose Folder") 
echo "$FILE"
FILE+=/$(eza -1 --sort=accessed --no-quotes -f "$FILE" | rofi -i -dmenu -p "Choose File")
echo "$FILE"
handlr open "${FILE}"
