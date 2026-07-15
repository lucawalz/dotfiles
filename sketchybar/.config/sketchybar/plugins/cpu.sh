#!/usr/bin/env bash

source "$(dirname "${BASH_SOURCE[0]}")/../colors.sh"

readonly HIGH_THRESHOLD=70
readonly MEDIUM_THRESHOLD=30

readonly ICON_CPU=""

USAGE="$(top -l 2 -n 0 -s 0 | awk '/^CPU usage/ {gsub("%", ""); usage = 100 - $7} END {printf "%.0f", usage}')"

if [ -z "$USAGE" ]; then
  exit 0
fi

if [ "$USAGE" -ge "$HIGH_THRESHOLD" ]; then
  COLOR="$CRITICAL"
elif [ "$USAGE" -ge "$MEDIUM_THRESHOLD" ]; then
  COLOR="$ELEVATED"
else
  COLOR="$IDLE"
fi

sketchybar --set "$NAME" icon="$ICON_CPU" icon.color="$COLOR" label="${USAGE}%"
