#!/usr/bin/env bash
set -u

FOCUS=$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)/focus.sh
AEROSPACE_CALL="aerospace focus --boundaries all-monitors-outer-frame --boundaries-action wrap-around-all-monitors"
SERVER=/tmp/nvim-test.sock

work=$(mktemp -d)
trap 'rm -rf "$work"' EXIT
lock=$work/state/nvim/aerospace-focus.lock

stub() {
  {
    echo '#!/usr/bin/env bash'
    echo "echo \"$1 \$*\" >>\"\$STUB_LOG\""
    cat
  } >"$work/$1"
  chmod +x "$work/$1"
}
stub aerospace </dev/null
stub nvim <<'STUB'
exit "${STUB_NVIM_STATUS:-0}"
STUB
# list-clients prints STUB_CLIENTS lines; display-message prints STUB_STATE (zoomed flag then edge flag)
stub tmux <<'STUB'
case $1 in
  list-clients) [[ -n ${STUB_NO_SERVER:-} ]] && exit 1; [[ -n ${STUB_CLIENTS:-} ]] && printf "%b\n" "$STUB_CLIENTS" ;;
  display-message) printf "%s\n" "$STUB_STATE" ;;
esac
STUB

failures=()

run() {
  local name=$1 want=$2
  shift 2
  : >"$work/log"
  env STUB_LOG="$work/log" XDG_STATE_HOME="$work/state" HOME=/nonexistent \
    AEROSPACE_BIN="$work/aerospace" NVIM_BIN="$work/nvim" TMUX_BIN="$work/tmux" \
    "$@" "$FOCUS" "${ARGS[@]}" >/dev/null 2>&1
  local got
  got=$(grep -v -e '^tmux list-clients' -e '^tmux display-message' "$work/log")
  [[ $got == "$want" ]] || failures+=("$name: want '$want', got '$got'")
}

ARGS=(left)
run "shell pane not at edge" "tmux select-pane -t %1 -L" \
  STUB_CLIENTS='100 %9\n200 %1' STUB_STATE=00
grep -Fq "tmux list-clients -f #{m:*focused*,#{client_flags}}" "$work/log" || failures+=("list-clients lacks the focused filter")
run "shell pane at edge" "$AEROSPACE_CALL left" STUB_CLIENTS='200 %1' STUB_STATE=01
run "zoomed pane" "$AEROSPACE_CALL left" STUB_CLIENTS='200 %1' STUB_STATE=10
run "no focused client" "$AEROSPACE_CALL left" STUB_STATE=00
run "no tmux server" "$AEROSPACE_CALL left" STUB_NO_SERVER=1 STUB_STATE=00

mkdir -p "$(dirname "$lock")"
echo "$SERVER" >"$lock"
run "live nvim lock" "nvim --server $SERVER --remote-expr v:lua.require'config.aerospace-focus'.focus('left')" \
  STUB_CLIENTS='200 %1' STUB_STATE=00
[[ -f $lock ]] || failures+=("live nvim lock: lock removed")

run "stale nvim lock" "nvim --server $SERVER --remote-expr v:lua.require'config.aerospace-focus'.focus('left')
tmux select-pane -t %1 -L" STUB_NVIM_STATUS=1 STUB_CLIENTS='200 %1' STUB_STATE=00
[[ -f $lock ]] && failures+=("stale nvim lock: lock kept")

echo "$SERVER" >"$lock"
ARGS=(--pane %4 down)
run "from nvim inside tmux" "tmux select-pane -t %4 -D" STUB_CLIENTS='200 %1' STUB_STATE=00
ARGS=(--pane '' down)
run "from nvim outside tmux" "$AEROSPACE_CALL down" STUB_CLIENTS='200 %1' STUB_STATE=00

ARGS=(sideways)
run "unknown direction" "" STUB_CLIENTS='200 %1' STUB_STATE=00

if ((${#failures[@]})); then
  printf 'focus: FAIL %s\n' "${failures[@]}" >&2
  exit 1
fi
echo "focus: ok"
