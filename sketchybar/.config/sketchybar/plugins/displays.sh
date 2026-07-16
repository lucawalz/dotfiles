#!/usr/bin/env bash

current="$(aerospace list-monitors 2>/dev/null | grep -c '|')"
[ -n "$current" ] && [ "$current" -ge 1 ] && [ "$current" != "$1" ] && sketchybar --reload
