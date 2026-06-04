#!/bin/bash
notify-send "WS" "id=$1 (dispatching...)"
/usr/bin/hyprctl dispatch "hl.dsp.focus({ workspace = \"$1\" })"
