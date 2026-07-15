#!/usr/bin/env bash

source "$(dirname "${BASH_SOURCE[0]}")/../colors.sh"

readonly FULL_THRESHOLD=75
readonly HIGH_THRESHOLD=50
readonly MEDIUM_THRESHOLD=25
readonly LOW_THRESHOLD=10

readonly ICON_CHARGING="󰂄"
readonly ICON_FULL="󰁹"
readonly ICON_HIGH="󰁿"
readonly ICON_MEDIUM="󰁽"
readonly ICON_LOW="󰁻"
readonly ICON_EMPTY="󰂎"

BATTERY_STATUS="$(pmset -g batt)"
PERCENTAGE="$(echo "$BATTERY_STATUS" | grep -Eo '[0-9]+%' | head -1 | tr -d '%')"

if [ -z "$PERCENTAGE" ]; then
  exit 0
fi

if echo "$BATTERY_STATUS" | grep -q "AC Power"; then
  ICON="$ICON_CHARGING"
  COLOR="$IDLE"
elif [ "$PERCENTAGE" -ge "$FULL_THRESHOLD" ]; then
  ICON="$ICON_FULL"
  COLOR="$NOMINAL"
elif [ "$PERCENTAGE" -ge "$HIGH_THRESHOLD" ]; then
  ICON="$ICON_HIGH"
  COLOR="$NOMINAL"
elif [ "$PERCENTAGE" -ge "$MEDIUM_THRESHOLD" ]; then
  ICON="$ICON_MEDIUM"
  COLOR="$WARNING"
elif [ "$PERCENTAGE" -ge "$LOW_THRESHOLD" ]; then
  ICON="$ICON_LOW"
  COLOR="$CRITICAL"
else
  ICON="$ICON_EMPTY"
  COLOR="$CRITICAL"
fi

sketchybar --set "$NAME" icon="$ICON" icon.color="$COLOR" label="${PERCENTAGE}%"
