#!/usr/bin/env bash

# pulls video and splits recordings into .avi files from my Panasonic camcorder
dvgrab -V -input "$1" --timestamp --size 0 --showstatus --autosplit --format dv2 dv-
rename -v 's/dv-19([0-9]{2}).([0-9]{2}).([0-9]{2})_([0-9]{2})-([0-9]{2})-([0-9]{2})/20$1$2$3T$4$5$6/' -- *
