#!/usr/bin/env bash
set -u

AEROSPACE_BIN=${AEROSPACE_BIN:-/opt/homebrew/bin/aerospace}
NVIM_BIN=${NVIM_BIN:-/opt/homebrew/bin/nvim}
TMUX_BIN=${TMUX_BIN:-/opt/homebrew/bin/tmux}
LOCK=${XDG_STATE_HOME:-$HOME/.local/state}/nvim/aerospace-focus.lock
NOT_ZOOMED_NOT_AT_EDGE=00

usage() {
  echo "usage: focus.sh [--pane <tmux pane id, empty outside tmux>] <left|down|up|right>" >&2
  exit 1
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
  if [[ -f $LOCK ]]; then
    server=$(<"$LOCK")
    if "$NVIM_BIN" --server "$server" \
      --remote-expr "v:lua.require'config.aerospace-focus'.focus('$direction')" >/dev/null 2>&1; then
      exit 0
    fi
    rm -f "$LOCK"
  fi
  # tmux keeps "focused" in client_flags from focus reports; a client counts as focused until its first focus-out, so the most recent activity breaks ties
  pane=$("$TMUX_BIN" list-clients -f '#{m:*focused*,#{client_flags}}' -F '#{client_activity} #{pane_id}' 2>/dev/null |
    sort -rn | head -n 1 | cut -d ' ' -f 2)
fi

if [[ -n $pane ]] &&
  [[ $("$TMUX_BIN" display-message -p -t "$pane" "#{window_zoomed_flag}#{$edge}" 2>/dev/null) == "$NOT_ZOOMED_NOT_AT_EDGE" ]]; then
  exec "$TMUX_BIN" select-pane -t "$pane" "$flag"
fi

exec "$AEROSPACE_BIN" focus \
  --boundaries all-monitors-outer-frame \
  --boundaries-action wrap-around-all-monitors "$direction"
