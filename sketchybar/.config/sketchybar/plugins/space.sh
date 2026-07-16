#!/usr/bin/env bash

source "$(dirname "${BASH_SOURCE[0]}")/../colors.sh"

SPACE="$1"

if yabai -m query --spaces --space "$SPACE" 2>/dev/null | grep -q '"is-visible":true'; then
  sketchybar --set "$NAME" background.drawing=on label.color="$ACCENT"
else
  sketchybar --set "$NAME" background.drawing=off label.color="$INACTIVE"
fi
