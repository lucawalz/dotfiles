#!/usr/bin/env bash

source "$(dirname "${BASH_SOURCE[0]}")/../colors.sh"

if [ "$SELECTED" = "true" ]; then
  sketchybar --set "$NAME" background.drawing=on icon.color="$ACCENT"
else
  sketchybar --set "$NAME" background.drawing=off icon.color="$INACTIVE"
fi
