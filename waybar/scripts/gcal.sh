#!/usr/bin/env bash
# Waybar calendar module — gcalcli integration
# Counts today's events from agenda output. Shows full agenda as tooltip.

GCALCLI="$HOME/.local/bin/gcalcli"
OAUTH_FILE="$HOME/.config/gcalcli/oauth.json"

if [ ! -f "$OAUTH_FILE" ]; then
  jq -nc '{text: "", tooltip: "Calendar not configured — click to set up", class: "not-configured"}'
  exit 0
fi

output=$($GCALCLI --nocolor --lineart unicode agenda 2>&1)
rc=$?

if [ $rc -ne 0 ]; then
  jq -nc '{text: " !", tooltip: "gcalcli error — check auth", class: "error"}'
  exit 0
fi

# Count lines containing today's date label (e.g. "Jun 02")
today_label=$(date +"%b %d")
count=$(echo "$output" | grep -c "$today_label")

jq -nc --arg tooltip "$output" --argjson count "$count" '{
  text: " \($count)",
  tooltip: $tooltip
}'
