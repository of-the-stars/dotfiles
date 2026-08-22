#!/usr/bin/env bash

#TODO: Add `fzf` to make this better at selecting multiple identities for the same URI

bw list items --search "$1" | jq '.[].login.password' | wl-copy
