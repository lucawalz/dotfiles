#!/usr/bin/env bash

source "$(dirname "${BASH_SOURCE[0]}")/../colors.sh"

layout_icon() {
  case "$(aerospace list-windows --focused --format '%{window-layout}' 2>/dev/null)" in
    h_accordion) printf '' ;;
    v_accordion) printf '' ;;
    h_tiles) printf '' ;;
    v_tiles) printf '' ;;
    floating) printf '󰉈' ;;
    *) printf '' ;;
  esac
}

case "$NAME" in
  front_app)
    [ "$SENDER" = "front_app_switched" ] && sketchybar --set "$NAME" label="$INFO"
    ;;
  front_app_layout)
    icon="$(layout_icon)"
    if [ -n "$icon" ]; then
      sketchybar --set "$NAME" icon="$icon" icon.drawing=on
    else
      sketchybar --set "$NAME" icon.drawing=off
    fi
    ;;
esac
