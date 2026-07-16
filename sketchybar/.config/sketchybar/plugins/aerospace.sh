#!/usr/bin/env bash

source "$(dirname "${BASH_SOURCE[0]}")/../colors.sh"
source "$(dirname "${BASH_SOURCE[0]}")/icon_map.sh"

focused="${FOCUSED_WORKSPACE:-$(aerospace list-workspaces --focused 2>/dev/null)}"

if [ "$1" = "$focused" ]; then
  sketchybar --set "$NAME" background.drawing=on icon.color="$ACCENT"
else
  sketchybar --set "$NAME" background.drawing=off icon.color="$INACTIVE"
fi

icons=""
while IFS= read -r app; do
  [ -z "$app" ] && continue
  __icon_map "$app"
  # shellcheck disable=SC2154
  icons+="$icon_result"
done < <(aerospace list-windows --workspace "$1" --format '%{app-name}' 2>/dev/null | sort -u)

if [ -n "$icons" ]; then
  sketchybar --set "$NAME" label="$icons" label.drawing=on
else
  sketchybar --set "$NAME" label.drawing=off
fi
