#!/usr/bin/env bash
# battery click handler — opens battery status TUI or power profile selector
# Left click: battery info TUI
# Right click: powerprofilesctl (original behavior)

TUI="$HOME/.config/waybar/scripts/battery_tui.py"

case "$1" in
  info|left)
    foot --title="battery" --hold -- python3 "$TUI"
    ;;
  profile|right)
    powerprofilesctl launch
    ;;
  *)
    foot --title="battery" --hold -- python3 "$TUI"
    ;;
esac
