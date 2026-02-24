#!/bin/bash

entries="🔒 Lock\n➜] Logout\n💤 Suspend\n♻️ Reboot\n🔴 Shutdown"

selected=$(echo -e $entries|wofi --width 250 --height 240 --dmenu --hide-search --cache-file /dev/null | awk '{print tolower($2)}')

case $selected in
  lock)
    hyprlock;;
  logout)
    hyprctl dispatch exit;;
  suspend)
    exec systemctl suspend;;
  reboot)
    exec systemctl reboot;;
  shutdown)
    exec systemctl poweroff;;
    # it used to be poweroff -i
esac
