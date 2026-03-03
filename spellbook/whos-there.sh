#!/usr/bin/env bash

temp="$(mktemp -t "whos-there-result.XXXXXX")"

STDIN="$(cat)"

if echo "$STDIN" | rg -q 'Starting Nmap'; then
    # If `knock-knock` or another invocation of `nmap -sL` was piped into it
    ip_list="$(echo "$STDIN" | rg 'Nmap scan report for' | awk '{print $5, $6}' | column -t )"
    echo "Runnin investigation on:"
    echo "$ip_list" 
    echo
    ip_list="$(echo "$ip_list" | sd '.+\((.+)\)$' \$1)"
else
    ip_list="$STDIN"
    echo "Runnin investigation on:"
    echo "$ip_list" 
    echo
fi

nmap -iL <(echo "$ip_list") -A -T4 | tee "$temp"
echo
echo "whos-there result stored at $temp"
