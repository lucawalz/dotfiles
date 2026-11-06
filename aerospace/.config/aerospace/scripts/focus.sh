#!/usr/bin/env bash
set -u

AEROSPACE_BIN=${AEROSPACE_BIN:-/opt/homebrew/bin/aerospace}
NVIM_BIN=${NVIM_BIN:-/opt/homebrew/bin/nvim}
TMUX_BIN=${TMUX_BIN:-/opt/homebrew/bin/tmux}
STATE=${XDG_STATE_HOME:-$HOME/.local/state}
LOCK=$STATE/nvim/aerospace-focus.lock
FOCUSED_CLIENT=$STATE/tmux/focused-client
GHOSTTY_BUNDLE_ID=com.mitchellh.ghostty
NOT_ZOOMED_NOT_AT_EDGE=00

usage() {
  echo "usage: focus.sh [--pane <tmux pane id, empty outside tmux>] <left|down|up|right>" >&2
  exit 1
}

aerospace_focus() {
  exec "$AEROSPACE_BIN" focus \
    --boundaries all-monitors-outer-frame \
    --boundaries-action wrap-around-all-monitors "$direction"
}

from_nvim=
if [[ ${1:-} == --pane ]]; then
  (($# == 3)) || usage
  from_nvim=1 pane=$2
  shift 2
fi
(($# == 1)) || usage
direction=$1
case $direction in
  left) flag=-L edge=pane_at_left ;;
  down) flag=-D edge=pane_at_bottom ;;
  up) flag=-U edge=pane_at_top ;;
  right) flag=-R edge=pane_at_right ;;
  *) usage ;;
esac

if [[ -z $from_nvim ]]; then
  [[ $("$AEROSPACE_BIN" list-windows --focused --format '%{app-bundle-id}' 2>/dev/null) == "$GHOSTTY_BUNDLE_ID" ]] ||
    aerospace_focus

  pane=
  client=$(cat "$FOCUSED_CLIENT" 2>/dev/null)
  if [[ -n $client ]]; then
    # display-message -c silently falls back to another client when the named one is gone
    pane=$("$TMUX_BIN" list-clients -f "#{==:#{client_name},$client}" -F '#{pane_id}' 2>/dev/null)
  fi

  if [[ -f $LOCK ]]; then
    { read -r server; read -r lock_pane; } <"$LOCK"
    if [[ -z $lock_pane || $lock_pane == "$pane" ]]; then
      if "$NVIM_BIN" --server "$server" \
        --remote-expr "v:lua.require'config.aerospace-focus'.focus('$direction')" >/dev/null 2>&1; then
        exit 0
      fi
      rm -f "$LOCK"
    fi
  fi
fi

if [[ -n $pane ]] &&
  [[ $("$TMUX_BIN" display-message -p -t "$pane" "#{window_zoomed_flag}#{$edge}" 2>/dev/null) == "$NOT_ZOOMED_NOT_AT_EDGE" ]]; then
  exec "$TMUX_BIN" select-pane -t "$pane" "$flag"
fi

aerospace_focus
