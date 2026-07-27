#!/usr/bin/env bash

declare -a directories=("Audio" "Documents" "dotfiles" "Downloads" "Log4Stell" "Music" "Pictures" "Programs" "Videos")

picker() {
    fzf \
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
        --padding 5,5 
}

partition="$(fd --full-path "$(lsblk --output NAME,SIZE,TYPE,MOUNTPOINT | rg -e 'part' | picker --border-label ' Choose which device partition to use '| awk '{print $1}' | sd '([^A-Za-z0-9])' "$1")" /dev)"

mountpoint="$(mktemp --directory)"

sudo mount "$partition" "$mountpoint"

backupDirectory="$(eza -1 -D --absolute=on "$mountpoint" | picker --border-label ' Choose which directory to back up into ' | sd '([^A-Za-z0-9/])' "$1")"

userToBackup="$(eza -1 -D --absolute=on /home | picker --border-label ' Choose which user to back up ')"

echo "$partition" 
echo "$mountpoint"
echo "$userToBackup"
echo "$backupDirectory"

printf "$userToBackup/%s\0" "${directories[@]}" | xargs -0 -I _ rsync -av --dry-run --progress --verbose --human-readable _ "$backupDirectory"
