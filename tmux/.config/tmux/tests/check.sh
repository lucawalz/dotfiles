#!/usr/bin/env bash
set -u

ROOT=$(cd "$(dirname "${BASH_SOURCE[0]}")/../../../.." && pwd)
CONF=${CONF:-$ROOT/tmux/.config/tmux/tmux.conf}
SOCKET=dotfiles-test
SESSION=check

# scope:option:expected-substring; scope is g (session), s (server) or w (window)
OPTIONS=(
  "g:allow-passthrough:on"
  "g:focus-events:on"
  "s:extended-keys:on"
  "g:mouse:on"
  "s:set-clipboard:on"
  "g:base-index:1"
  "w:pane-base-index:1"
  "g:renumber-windows:on"
  "g:status-position:bottom"
  "w:mode-keys:vi"
  "g:status-style:bg=default"
  "s:terminal-features:extkeys"
  "s:terminal-features:RGB"
  "s:terminal-features:usstyle"
)

# key-table:key-pattern
BINDINGS=()

tm() { tmux -L "$SOCKET" "$@"; }

cleanup() { tm kill-server 2>/dev/null; }
trap cleanup EXIT
cleanup

failures=()

if [[ ! -f $CONF ]]; then
  echo "tmux: missing config $CONF" >&2
  exit 1
fi

tm -f "$CONF" start-server \; new-session -d -s "$SESSION" || {
  echo "tmux: server failed to start with $CONF" >&2
  exit 1
}

for entry in "${OPTIONS[@]}"; do
  IFS=: read -r scope opt want <<<"$entry"
  case $scope in
    s) got=$(tm show -sv "$opt" 2>&1) ;;
    w) got=$(tm show -gwv "$opt" 2>&1) ;;
    *) got=$(tm show -gv "$opt" 2>&1) ;;
  esac
  [[ $got == *"$want"* ]] || failures+=("option $opt: want '$want', got '$got'")
done

keys=$(tm list-keys)
for entry in "${BINDINGS[@]}"; do
  IFS=: read -r table pattern <<<"$entry"
  grep -Eq -- "-T $table +$pattern " <<<"$keys" || failures+=("binding $table $pattern missing")
done

if ((${#failures[@]})); then
  printf 'tmux: FAIL %s\n' "${failures[@]}" >&2
  exit 1
fi
echo "tmux: ok"
