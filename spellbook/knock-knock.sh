#!/usr/bin/env bash

temp="$(mktemp -t "knock-knock-result.XXXXXX")"
IP_ADDR="$(ip address | rg inet | awk '{print $2}' | sed '3q;d')"
echo "IP Address: $IP_ADDR"
nmap -sL -T4 "$IP_ADDR" | rg -v '^Nmap scan report for \d+\.\d+\.\d+\.\d+$' | tee "$temp"
echo
echo "knock-knock result stored at $temp"
