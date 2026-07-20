#!/bin/bash

SB=/opt/homebrew/bin/sketchybar

REST_COLOR=0x59161616
REST_BORDER=0x40f2f4f8
DOT_COLOR=0xff161616
DOT_BORDER=0xff3ddbd9
GLOW_BORDER=0xfff2f4f8
DOT_MARGIN=940
PULSES=${PULSES:-2}
PULSE_TICKS=${PULSE_TICKS:-14}
PULSE_HOLD=${PULSE_HOLD:-0.24}

DOT_ICON_PAD=4
REST_ICON_PAD=8

restore() {
  $SB --set apple icon.padding_left=$REST_ICON_PAD icon.padding_right=$REST_ICON_PAD
  $SB --set '/.*/' drawing=on
  $SB --bar margin=10 corner_radius=12 y_offset=6 \
    color=$REST_COLOR border_color=$REST_BORDER border_width=1
}
trap restore EXIT

$SB --set '/.*/' drawing=off
$SB --set apple drawing=on icon.padding_left=$DOT_ICON_PAD
$SB --bar margin=$DOT_MARGIN corner_radius=18 y_offset=-45 \
  color=$DOT_COLOR border_color=$DOT_BORDER border_width=2
sleep 0.2

$SB --animate sin 18 --bar y_offset=6
sleep 0.35

for _ in $(seq 1 "$PULSES"); do
  $SB --animate sin "$PULSE_TICKS" --bar border_color=$GLOW_BORDER
  sleep "$PULSE_HOLD"
  $SB --animate sin "$PULSE_TICKS" --bar border_color=$DOT_BORDER
  sleep "$PULSE_HOLD"
done

$SB --bar border_color=$GLOW_BORDER
$SB --animate sin 28 --bar margin=10 corner_radius=12 \
  color=$REST_COLOR border_color=$REST_BORDER border_width=1
sleep 0.52

$SB --set apple icon.padding_left=$REST_ICON_PAD
$SB --set '/.*/' drawing=on
$SB --bar margin=10 corner_radius=12 y_offset=6 \
  color=$REST_COLOR border_color=$REST_BORDER border_width=1
trap - EXIT
