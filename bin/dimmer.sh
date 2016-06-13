#!/bin/bash

readonly BACKLIGHT_FILE="/sys/class/backlight/intel_backlight/brightness"
oldBrightness=$(cat "$BACKLIGHT_FILE")

readonly INCREMENT=82
newBrightness=$((${oldBrightness}-${INCREMENT}))

# Clamp values
[ ${newBrightness} -lt 0 ] && newBrightness=0

sudo bash -c "echo ${newBrightness} > $BACKLIGHT_FILE"
