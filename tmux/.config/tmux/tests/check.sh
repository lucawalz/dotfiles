#!/usr/bin/env bash
set -u

ROOT=$(cd "$(dirname "${BASH_SOURCE[0]}")/../../../.." && pwd)
CONF=${CONF:-$ROOT/tmux/.config/tmux/tmux.conf}
SOCKET=dotfiles-test
SESSION=check

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

PREFIX_KEYS=('\%' '\"' c x E P 1 2 3 4 5 6 7 8 9)

BINDING_CONTENT=(
  '\%:pane_current_path'
  '\":pane_current_path'
  'c:pane_current_path'
  'P:sesh'
  'x:kill-pane'
  'E:select-layout -E'
)

ROOT_BINDING_CONTENT=(
  'C-h:pane_at_left'
  'C-j:pane_at_bottom'
  'C-k:pane_at_top'
  'C-l:pane_at_right'
  'C-Up:resize-pane -U 2'
  'C-Down:resize-pane -D 2'
  'C-Left:resize-pane -L 2'
  'C-Right:resize-pane -R 2'
)

GUARD_NAME=tmux_attach_project
FOCUS_WAIT_TRIES=50
FOCUS_WAIT_STEP=0.1

tm() { tmux -L "$SOCKET" "$@"; }

state=$(cd -P "$(mktemp -d)" && pwd)
export XDG_STATE_HOME=$state
focused_file=$state/tmux/focused-client

cleanup() {
  tm kill-server 2>/dev/null
  rm -rf "$state"
}
trap cleanup EXIT
tm kill-server 2>/dev/null

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

keys=$(tm list-keys | tr -s " ")
for key in "${PREFIX_KEYS[@]}"; do
  grep -Fq -- "-T prefix $key " <<<"$keys" || failures+=("binding prefix $key missing")
done
for entry in "${BINDING_CONTENT[@]}"; do
  key=${entry%:*} want=${entry##*:}
  grep -F -- "-T prefix $key " <<<"$keys" | grep -Fq -- "$want" || failures+=("binding prefix $key lacks '$want'")
done

for entry in "${ROOT_BINDING_CONTENT[@]}"; do
  key=${entry%%:*} want=${entry#*:}
  grep -F -- "-T root $key " <<<"$keys" | grep -Fq -- "$want" || failures+=("binding root $key lacks '$want'")
done

for key in C-h C-j C-k C-l; do
  grep -F -- "-T prefix $key " <<<"$keys" | grep -Fq -- "send-keys $key" || failures+=("binding prefix $key lacks passthrough")
done

grep -F -- "-T prefix x " <<<"$keys" | grep -Fq confirm-before && failures+=("binding prefix x still confirms")

zsh -n "$ROOT/zsh/.zshrc" || failures+=("zsh syntax error in .zshrc")

stub=$(cd -P "$(mktemp -d)" && pwd)
printf '#!/bin/sh\necho "stub-tmux $*"\n' >"$stub/tmux"
chmod +x "$stub/tmux"
GUARD_RUN="source <(sed -n '/^$GUARD_NAME() {/,/^}/p' '$ROOT/zsh/.zshrc'); $GUARD_NAME; echo returned"
guard_tty() { echo | script -q /dev/null env -i "$@" "$(command -v zsh)" -c "$GUARD_RUN" | tr -d "\r" | tail -n 1; }
guard_pipe() { env -i "$@" "$(command -v zsh)" -c "$GUARD_RUN" | cat; }
inside=$(guard_tty PATH="$stub:/usr/bin:/bin" TMUX=set TERM_PROGRAM=ghostty)
[[ $inside == returned ]] || failures+=("guard inside tmux: want 'returned', got '$inside'")
notmux=$(guard_tty PATH=/usr/bin:/bin TERM_PROGRAM=ghostty)
[[ $notmux == returned ]] || failures+=("guard without tmux: want 'returned', got '$notmux'")
other=$(guard_tty PATH="$stub:/usr/bin:/bin" TERM_PROGRAM=other)
[[ $other == returned ]] || failures+=("guard outside ghostty: want 'returned', got '$other'")
notty=$(guard_pipe PATH="$stub:/usr/bin:/bin" TERM_PROGRAM=ghostty)
[[ $notty == returned ]] || failures+=("guard without tty: want 'returned', got '$notty'")
mkdir -p "$stub/my.proj:x"
named=$(cd "$stub/my.proj:x" && guard_tty PATH="$stub:/usr/bin:/bin" HOME=/nonexistent TERM_PROGRAM=ghostty)
[[ $named == "stub-tmux new-session -A -s my_proj_x" ]] || failures+=("guard name: got '$named'")
homed=$(cd "$stub" && guard_tty PATH="$stub:/usr/bin:/bin" HOME="$stub" TERM_PROGRAM=ghostty)
[[ $homed == "stub-tmux new-session -A -s home" ]] || failures+=("guard home: got '$homed'")
rm -rf "$stub"

hooks=$(tm show-hooks -g)
for hook in client-focus-in client-focus-out; do
  grep -F -- "$hook" <<<"$hooks" | grep -Fq focused-client || failures+=("hook $hook lacks focused-client")
done

wait_for_file() {
  local want=$1 i
  for ((i = 0; i < FOCUS_WAIT_TRIES; i++)); do
    [[ $(cat "$focused_file" 2>/dev/null) == "$want" ]] && return 0
    sleep "$FOCUS_WAIT_STEP"
  done
  return 1
}

await_flag() {
  local i
  for ((i = 0; i < FOCUS_WAIT_TRIES; i++)); do
    [[ -e $state/$1 ]] && return 0
    sleep "$FOCUS_WAIT_STEP"
  done
  return 1
}

# script(1) rejects a fifo on stdin, so focus reports are fed through a pipe gated by flag files
{
  await_flag focus-in && printf '\033[I'
  await_flag focus-out && printf '\033[O'
  await_flag finished
} | TERM=xterm-256color script -q /dev/null tmux -L "$SOCKET" attach -t "$SESSION" >/dev/null 2>&1 &
client=
for ((i = 0; i < FOCUS_WAIT_TRIES && ${#client} == 0; i++)); do
  client=$(tm list-clients -F '#{client_name}')
  [[ -n $client ]] || sleep "$FOCUS_WAIT_STEP"
done
if [[ -z $client ]]; then
  failures+=("focus hooks: test client did not attach")
else
  touch "$state/focus-in"
  wait_for_file "$client" || failures+=("focus-in hook: want '$client' in $focused_file, got '$(cat "$focused_file" 2>&1)'")
  touch "$state/focus-out"
  wait_for_file "" || failures+=("focus-out hook: $focused_file still holds '$(cat "$focused_file" 2>&1)'")
fi
touch "$state/finished"

if ((${#failures[@]})); then
  printf 'tmux: FAIL %s\n' "${failures[@]}" >&2
  exit 1
fi
echo "tmux: ok"
