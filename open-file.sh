#!/usr/bin/env bash

FILE=$(eza -1 --absolute=follow -R -D | rofi -dmenu) 
FILE+=/$(eza -1 -f --sort=accessed "$FILE" | rofi -dmenu)
xdg-open "${FILE}"
