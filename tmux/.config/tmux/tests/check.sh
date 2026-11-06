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

PREFIX_KEYS=('\%' '\"' c x E P 1 2 3 4 5 6 7 8 9)

# key:required-substring
BINDING_CONTENT=(
  '\%:pane_current_path'
  '\":pane_current_path'
  'c:pane_current_path'
  'P:sesh'
  'x:kill-pane'
  'E:select-layout -E'
)

GUARD_NAME=tmux_attach_project

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

keys=$(tm list-keys | tr -s " ")
for key in "${PREFIX_KEYS[@]}"; do
  grep -Fq -- "-T prefix $key " <<<"$keys" || failures+=("binding prefix $key missing")
done
for entry in "${BINDING_CONTENT[@]}"; do
  key=${entry%:*} want=${entry##*:}
  grep -F -- "-T prefix $key " <<<"$keys" | grep -Fq -- "$want" || failures+=("binding prefix $key lacks '$want'")
done

grep -F -- "-T prefix x " <<<"$keys" | grep -Fq confirm-before && failures+=("binding prefix x still confirms")

zsh -n "$ROOT/zsh/.zshrc" || failures+=("zsh syntax error in .zshrc")

stub=$(cd -P "$(mktemp -d)" && pwd)
printf '#!/bin/sh\necho "stub-tmux $*"\n' >"$stub/tmux"
chmod +x "$stub/tmux"
inside=$(env -i PATH="$stub:/usr/bin:/bin" TMUX=set TERM_PROGRAM=ghostty "$(command -v zsh)" -c "source <(sed -n '/^$GUARD_NAME() {/,/^}/p' '$ROOT/zsh/.zshrc'); $GUARD_NAME; echo returned")
[[ $inside == returned ]] || failures+=("guard inside tmux: want 'returned', got '$inside'")
notmux=$(env -i PATH=/usr/bin:/bin TERM_PROGRAM=ghostty "$(command -v zsh)" -c "source <(sed -n '/^$GUARD_NAME() {/,/^}/p' '$ROOT/zsh/.zshrc'); $GUARD_NAME; echo returned")
[[ $notmux == returned ]] || failures+=("guard without tmux: want 'returned', got '$notmux'")
other=$(env -i PATH="$stub:/usr/bin:/bin" TERM_PROGRAM=other "$(command -v zsh)" -c "source <(sed -n '/^$GUARD_NAME() {/,/^}/p' '$ROOT/zsh/.zshrc'); $GUARD_NAME; echo returned")
[[ $other == returned ]] || failures+=("guard outside ghostty: want 'returned', got '$other'")
mkdir -p "$stub/my.proj:x"
named=$(cd "$stub/my.proj:x" && env -i PATH="$stub:/usr/bin:/bin" HOME=/nonexistent TERM_PROGRAM=ghostty "$(command -v zsh)" -c "source <(sed -n '/^$GUARD_NAME() {/,/^}/p' '$ROOT/zsh/.zshrc'); $GUARD_NAME; echo returned")
[[ $named == "stub-tmux new-session -A -s my_proj_x" ]] || failures+=("guard name: got '$named'")
homed=$(cd "$stub" && env -i PATH="$stub:/usr/bin:/bin" HOME="$stub" TERM_PROGRAM=ghostty "$(command -v zsh)" -c "source <(sed -n '/^$GUARD_NAME() {/,/^}/p' '$ROOT/zsh/.zshrc'); $GUARD_NAME; echo returned")
[[ $homed == "stub-tmux new-session -A -s home" ]] || failures+=("guard home: got '$homed'")
rm -rf "$stub"

if ((${#failures[@]})); then
  printf 'tmux: FAIL %s\n' "${failures[@]}" >&2
  exit 1
fi
echo "tmux: ok"
