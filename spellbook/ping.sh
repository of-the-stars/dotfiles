#!/usr/bin/env bash

temp="$(mktemp -t "ping-result.XXXXXX")"
IP_ADDR="$(ip address | rg inet | awk '{print $2}' | sed '3q;d')"
echo "IP Address: $IP_ADDR"
nmap -sL -A -v "$IP_ADDR" | tee "$temp" | bat --paging=never -pl log
nvim "$temp"
rm -f -- "$temp"
