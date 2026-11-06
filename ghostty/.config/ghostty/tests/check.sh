#!/usr/bin/env bash
set -u

ROOT=$(cd "$(dirname "${BASH_SOURCE[0]}")/../../../.." && pwd)
CONF=${CONF:-$ROOT/ghostty/.config/ghostty/config}
GHOSTTY=${GHOSTTY:-/Applications/Ghostty.app/Contents/MacOS/ghostty}
SPLIT_TAB_ACTIONS='(new_split|goto_split|resize_split|equalize_splits|toggle_split_zoom|new_tab|goto_tab|close_tab|move_tab|previous_tab|next_tab|last_tab)'
EXPECTED=(
  'super+d=text:\x02%'
  'super+shift+d=text:\x02\x22'
  'super+shift+e=text:\x02E'
  'super+t=text:\x02c'
  'super+w=text:\x02x'
  'super+p=text:\x02P'
  'super+h=text:\x08'
  'super+j=text:\x0a'
  'super+k=text:\x0b'
  'super+l=text:\x0c'
  'super+n=new_window'
  'super+enter=csi:13;2u'
  'super+i=inspector:toggle'
  'super+backquote=toggle_quick_terminal'
)
for digit in 1 2 3 4 5 6 7 8 9; do
  EXPECTED+=("super+$digit=text:\\x02$digit")
done

fail=0
check() {
  if ! "$@"; then
    fail=1
  fi
}

home=$(mktemp -d)
trap 'rm -rf "$home"' EXIT
mkdir -p "$home/.config/ghostty"
cp "$CONF" "$home/.config/ghostty/config"
cp -R "$(dirname "$CONF")/shaders" "$home/.config/ghostty/" 2>/dev/null

ghostty() { HOME=$home XDG_CONFIG_HOME=$home/.config "$GHOSTTY" "$@"; }

check ghostty +validate-config || echo "FAIL: config does not validate"
binds=$(ghostty +list-keybinds --plain)

leftover=$(grep -E "=$SPLIT_TAB_ACTIONS(:|$)" <<<"$binds")
if [ -n "$leftover" ]; then
  echo "FAIL: split or tab binds remain:"
  echo "$leftover"
  fail=1
fi

for want in "${EXPECTED[@]}"; do
  if ! grep -qxF "keybind = $want" <<<"$binds"; then
    echo "FAIL: missing keybind $want"
    fail=1
  fi
done

[ "$fail" -eq 0 ] && echo "ghostty config ok"
exit "$fail"
