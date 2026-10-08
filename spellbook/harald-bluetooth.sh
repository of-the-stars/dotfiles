#!/usr/bin/env bash

device="$(bluetoothctl devices | rofi -i -dmenu -p "Choose Device" | awk '{print $2}')"

bluetoothctl connect "$device"
