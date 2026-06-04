#!/usr/bin/env bash
MAX=30
SPEED=3

status=$(audtool --playback-status 2>/dev/null)

case "$status" in
  playing)
    symbol=""
    ;;
  paused)
    symbol=""
    ;;
  *)
    echo ""
    exit 0
    ;;
esac

text="$(audtool --current-song 2>/dev/null)    "  # pad for smooth scroll
len=${#text}

offset=$(( ($(date +%s) * SPEED) % len ))
visible="${text:$offset:$MAX}"

# wrap if slice is shorter than MAX
if [ ${#visible} -lt $MAX ]; then
  visible="$visible${text:0:$((MAX - ${#visible}))}"
fi

echo "$symbol  $visible"
