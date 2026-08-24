#!/usr/bin/env bash

device="$(bluetoothctl devices | fzf \
        --color='border:blue' \
        --color='label:white:bold' \
        --color='list-bg:-1' \
        --color='gutter:-1' \
        --color='hl:blue:bold' \
        --color='hl+:green:bold' \
        --color='fg+:white' \
        --color='info:white' \
        --color='pointer:green' \
        --tac \
        --border \
        --margin=10% \
        --padding 5,5 \
        | awk '{print $2}')"

bluetoothctl connect "$device"
