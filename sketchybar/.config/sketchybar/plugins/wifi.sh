#!/usr/bin/env bash

source "$(dirname "${BASH_SOURCE[0]}")/../colors.sh"

readonly ICON_CONNECTED="󰖩"
readonly ICON_DISCONNECTED="󰖪"
readonly FALLBACK_LABEL="Wi-Fi"
readonly OFFLINE_LABEL="Offline"

INTERFACE="$(networksetup -listallhardwareports | awk '/Wi-Fi/ {getline; print $2}')"

if [ -z "$INTERFACE" ] || [ "$(ifconfig "$INTERFACE" 2>/dev/null | awk '/status:/ {print $2}')" != "active" ]; then
  sketchybar --set "$NAME" icon="$ICON_DISCONNECTED" icon.color="$INACTIVE" \
    label="$OFFLINE_LABEL" label.color="$INACTIVE" \
    --set "$NAME.ssid" label="$OFFLINE_LABEL" icon.color="$INACTIVE" \
    --set "$NAME.ip" label="-"
  exit 0
fi

SSID="$(ipconfig getsummary "$INTERFACE" 2>/dev/null | sed -n 's/^[[:space:]]*SSID[[:space:]]*:[[:space:]]*//p')"

# macOS gates SSID reads behind Location Services and yields <redacted> until it is granted
if [ "$SSID" = "<redacted>" ]; then
  SSID=""
fi

IP="$(ipconfig getifaddr "$INTERFACE" 2>/dev/null)"

sketchybar --set "$NAME" icon="$ICON_CONNECTED" icon.color="$NETWORK" \
  label="${SSID:-$FALLBACK_LABEL}" label.color="$FOREGROUND" \
  --set "$NAME.ssid" label="${SSID:-$FALLBACK_LABEL}" icon.color="$NETWORK" \
  --set "$NAME.ip" label="${IP:--}"
