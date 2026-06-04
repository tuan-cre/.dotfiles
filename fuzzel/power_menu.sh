#!/bin/bash

options=" Shutdown
 Reboot
󰤄 Sleep
󰍃 Logout"

choice=$(echo -e "$options" | fuzzel --dmenu --prompt "Power: ")

case "$choice" in
  *Shutdown) systemctl poweroff ;;
  *Reboot) systemctl reboot ;;
  *Sleep) systemctl suspend ;;
  *Logout) pkill -x Hyprland ;;
esac
