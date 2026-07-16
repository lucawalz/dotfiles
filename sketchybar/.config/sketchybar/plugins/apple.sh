#!/usr/bin/env bash

if [ "$SENDER" = "mouse.exited.global" ]; then
  sketchybar --set apple popup.drawing=off
fi
