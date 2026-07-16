#!/usr/bin/env bash

source "$(dirname "${BASH_SOURCE[0]}")/../colors.sh"

if [ "$SENDER" = "volume_change" ]; then
  vol="$INFO"
else
  vol="$(osascript -e 'output volume of (get volume settings)')"
fi

case "$vol" in
  [6-9][0-9]|100) icon='󰕾' ;;
  [3-5][0-9]) icon='󰖀' ;;
  [1-9]|[1-2][0-9]) icon='󰕿' ;;
  *) icon='󰖁' ;;
esac

sketchybar --set "$NAME" icon="$icon" label="$vol%"
