#!/usr/bin/env bash

# pulls video and splits recordings into .avi files from my Panasonic camcorder
dvgrab -V -input $1 --timestamp --size 0 --showstatus --autosplit --format dv2 dv-

