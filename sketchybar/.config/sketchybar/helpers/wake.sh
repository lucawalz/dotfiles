#!/bin/bash

SB=/opt/homebrew/bin/sketchybar

REST_COLOR=0x59161616
REST_BORDER=0x40f2f4f8
ORB_BORDER=0xff3ddbd9
GLOW_BORDER=0xfff2f4f8
CLEAR=0x00000000

HIDDEN_OFFSET=${HIDDEN_OFFSET:-80}
DROP_FROM=${DROP_FROM:-45}
PULSES=${PULSES:-2}
PULSE_TICKS=${PULSE_TICKS:-14}
PULSE_HOLD=${PULSE_HOLD:-0.24}
OPEN_FROM=${OPEN_FROM:-1000}

restore() {
  $SB --set '/.*/' y_offset=0
  $SB --set media drawing=on
  $SB --set wake.orb drawing=off y_offset=0
  $SB --bar margin=10 corner_radius=12 y_offset=6 \
    color=$REST_COLOR border_color=$REST_BORDER border_width=1
}
trap restore EXIT

$SB --set '/.*/' y_offset="$HIDDEN_OFFSET"
$SB --set media drawing=off
$SB --bar margin=10 corner_radius=12 y_offset=6 color=$CLEAR border_width=0
$SB --set wake.orb drawing=on y_offset="$DROP_FROM" background.border_color=$ORB_BORDER
sleep 0.2

$SB --animate sin 18 --set wake.orb y_offset=0
sleep 0.35

for _ in $(seq 1 "$PULSES"); do
  $SB --animate sin "$PULSE_TICKS" --set wake.orb background.border_color=$GLOW_BORDER
  sleep "$PULSE_HOLD"
  $SB --animate sin "$PULSE_TICKS" --set wake.orb background.border_color=$ORB_BORDER
  sleep "$PULSE_HOLD"
done

$SB --set wake.orb drawing=off
$SB --bar margin="$OPEN_FROM" border_color=$GLOW_BORDER border_width=1
$SB --animate sin 28 --bar margin=10 color=$REST_COLOR border_color=$REST_BORDER
sleep 0.52

$SB --set '/.*/' y_offset=0
$SB --set media drawing=on
$SB --set wake.orb drawing=off y_offset=0
$SB --bar margin=10 corner_radius=12 y_offset=6 \
  color=$REST_COLOR border_color=$REST_BORDER border_width=1
trap - EXIT
