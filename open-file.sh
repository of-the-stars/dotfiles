#!/usr/bin/env bash

FILE=$(eza -1 --absolute=follow -R -D | rofi -i -dmenu) 
echo "$FILE"
FILE+=/$(eza -1 -f --sort=accessed "$FILE" | rofi -i -dmenu)
echo "$FILE"
xdg-open "${FILE}"
