#!/usr/bin/env bash

bw list items --search "$1" | jq '.[].login.password' | wl-copy
