#!/usr/bin/env bash

FILE=$(eza -1 --absolute=follow -R --no-quotes -D | rofi -i -dmenu) 
echo "$FILE"
FILE+=/$(eza -1 -f --sort=accessed --no-quotes "$FILE" | rofi -i -dmenu)
echo "$FILE"
xdg-open "${FILE}"
