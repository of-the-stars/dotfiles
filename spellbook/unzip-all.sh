#!/usr/bin/env bash

for a in *.zip; do unzip "$a" -d "''${a%.zip}"; done
