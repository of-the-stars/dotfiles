#!/usr/bin/env bash

FILE=$(eza -1 --absolute=follow -R --no-quotes -D | rofi -i -dmenu -p "Choose Folder") 
echo "$FILE"
FILE+=/$(eza -1 -f --sort=accessed --no-quotes "$FILE" | rofi -i -dmenu -p "Choose File")
echo "$FILE"
handlr "${FILE}"
