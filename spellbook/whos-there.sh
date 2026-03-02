#!/usr/bin/env bash

temp="$(mktemp -t "whos-there-result.XXXXXX")"

STDIN="$(cat)"

door_knocked="$(echo "$STDIN" | rg -q 'Starting Nmap')" 

if $door_knocked; then
    ip_list="$(echo "$STDIN" | rg 'Nmap scan report for' | awk '{print $5, $6}' | column -t )"
else
    ip_list=$STDIN
fi

echo "Runnin investigation on:"
echo "$ip_list" 
echo

nmap -iL <(echo "$ip_list" | sd '.+\((.+)\)$' \$1) -v -A -T4 | tee "$temp"
echo
echo "whos-there result stored at $temp"
