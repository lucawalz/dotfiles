#!/usr/bin/env bash
set -u

FOCUS=$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)/focus.sh
GHOSTTY=com.mitchellh.ghostty
CLIENT=/dev/ttys001
DEAD_CLIENT=/dev/ttys002
SERVER=/tmp/nvim-test.sock

work=$(cd -P "$(mktemp -d)" && pwd)
trap 'rm -rf "$work"' EXIT
export HOME=$work XDG_STATE_HOME=$work/state
export AEROSPACE_BIN=$work/aerospace NVIM_BIN=$work/nvim TMUX_BIN=$work/tmux STUB_LOG=$work/log
for bin in AEROSPACE_BIN NVIM_BIN TMUX_BIN XDG_STATE_HOME; do
  [[ ${!bin} == "$work"/* ]] || {
    echo "focus: $bin is not inside the test dir, aborting" >&2
    exit 1
  }
done
lock=$XDG_STATE_HOME/nvim/aerospace-focus.lock
focused=$XDG_STATE_HOME/tmux/focused-client
mkdir -p "$(dirname "$lock")" "$(dirname "$focused")"

stub() {
  {
    echo '#!/usr/bin/env bash'
    echo "echo \"$1 \$*\" >>\"\$STUB_LOG\""
    cat
  } >"$work/$1"
  chmod +x "$work/$1"
}
stub aerospace <<'STUB'
[[ $1 == list-windows ]] && echo "$STUB_APP"
STUB
stub nvim <<'STUB'
exit "${STUB_NVIM_STATUS:-0}"
STUB
# display-message prints STUB_STATE: the zoomed flag, then the edge flag
stub tmux <<'STUB'
case $1 in
  list-clients)
    [[ -n ${STUB_NO_SERVER:-} ]] && exit 1
    [[ $3 == *",$STUB_LIVE_CLIENT}" ]] && echo "$STUB_ACTIVE_PANE"
    ;;
  display-message) echo "$STUB_STATE" ;;
esac
STUB

APP="aerospace list-windows --focused --format %{app-bundle-id}"
CLIENTS="tmux list-clients -f #{==:#{client_name},$CLIENT} -F #{pane_id}"
rpc() { echo "nvim --server $SERVER --remote-expr v:lua.require'config.aerospace-focus'.focus('$1')"; }
state() { echo "tmux display-message -p -t $1 #{window_zoomed_flag}#{$2}"; }
aero() { echo "aerospace focus --boundaries all-monitors-outer-frame --boundaries-action wrap-around-all-monitors $1"; }
lines() { printf '%s\n' "$@"; }

failures=()

run() {
  local name=$1 want=$2
  shift 2
  : >"$STUB_LOG"
  env STUB_APP=$GHOSTTY STUB_LIVE_CLIENT=$CLIENT STUB_ACTIVE_PANE=%1 STUB_STATE=00 \
    "$@" "$FOCUS" "${ARGS[@]}" >/dev/null 2>&1
  local got
  got=$(<"$STUB_LOG")
  [[ $got == "$want" ]] || failures+=("$name: want '$want', got '$got'")
}

echo "$CLIENT" >"$focused"
ARGS=(left)
run "shell pane not at left edge" "$(lines "$APP" "$CLIENTS" "$(state %1 pane_at_left)" "tmux select-pane -t %1 -L")"
ARGS=(right)
run "shell pane not at right edge" "$(lines "$APP" "$CLIENTS" "$(state %1 pane_at_right)" "tmux select-pane -t %1 -R")"
ARGS=(down)
run "shell pane at bottom edge" "$(lines "$APP" "$CLIENTS" "$(state %1 pane_at_bottom)" "$(aero down)")" STUB_STATE=01
ARGS=(up)
run "zoomed pane" "$(lines "$APP" "$CLIENTS" "$(state %1 pane_at_top)" "$(aero up)")" STUB_STATE=10
ARGS=(left)
run "no tmux server" "$(lines "$APP" "$CLIENTS" "$(aero left)")" STUB_NO_SERVER=1
run "frontmost app not ghostty" "$(lines "$APP" "$(aero left)")" STUB_APP=com.apple.Safari

echo "$DEAD_CLIENT" >"$focused"
run "focused client gone" "$(lines "$APP" "tmux list-clients -f #{==:#{client_name},$DEAD_CLIENT} -F #{pane_id}" "$(aero left)")"
rm -f "$focused"
run "no focused client file" "$(lines "$APP" "$(aero left)")"

lines "$SERVER" "" >"$lock"
run "nvim lock outside tmux" "$(lines "$APP" "$(rpc left)")"
[[ -f $lock ]] || failures+=("nvim lock outside tmux: lock removed")

echo "$CLIENT" >"$focused"
lines "$SERVER" %1 >"$lock"
run "nvim lock in active pane" "$(lines "$APP" "$CLIENTS" "$(rpc left)")"
[[ -f $lock ]] || failures+=("nvim lock in active pane: lock removed")
run "nvim lock with ghostty in background" "$(lines "$APP" "$(aero left)")" STUB_APP=com.apple.Safari
lines "$SERVER" %7 >"$lock"
run "nvim lock in another pane" "$(lines "$APP" "$CLIENTS" "$(state %1 pane_at_left)" "tmux select-pane -t %1 -L")"
[[ -f $lock ]] || failures+=("nvim lock in another pane: lock removed")
lines "$SERVER" %1 >"$lock"
run "stale nvim lock" "$(lines "$APP" "$CLIENTS" "$(rpc left)" "$(state %1 pane_at_left)" "tmux select-pane -t %1 -L")" \
  STUB_NVIM_STATUS=1
[[ -f $lock ]] && failures+=("stale nvim lock: lock kept")

lines "$SERVER" %4 >"$lock"
ARGS=(--pane %4 down)
run "from nvim inside tmux" "$(lines "$(state %4 pane_at_bottom)" "tmux select-pane -t %4 -D")"
ARGS=(--pane %4 up)
run "from nvim at tmux top edge" "$(lines "$(state %4 pane_at_top)" "$(aero up)")" STUB_STATE=01
ARGS=(--pane '' down)
run "from nvim outside tmux" "$(aero down)"

ARGS=(sideways)
run "unknown direction" ""

if ((${#failures[@]})); then
  printf 'focus: FAIL %s\n' "${failures[@]}" >&2
  exit 1
fi
echo "focus: ok"
