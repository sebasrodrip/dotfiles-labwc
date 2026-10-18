#!/bin/bash
# ~/.config/labwc/scripts/tearing-toggle.sh
STATE_FILE="$HOME/.cache/labwc-tearing-state"
if [[ -f "$STATE_FILE" ]]; then
  rm "$STATE_FILE"
  notify-send "Tearing" "Disabled" -t 1500
else
  touch "$STATE_FILE"
  notify-send "Tearing" "Enabled" -t 1500
fi
