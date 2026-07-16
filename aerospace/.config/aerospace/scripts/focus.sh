#!/usr/bin/env bash

direction="$1"
lock="$HOME/.local/state/nvim/aerospace-focus.lock"

if [[ -f "$lock" ]]; then
  server="$(<"$lock")"
  if /opt/homebrew/bin/nvim --server "$server" \
    --remote-expr "v:lua.require'config.aerospace-focus'.focus('$direction')" >/dev/null 2>&1; then
    exit 0
  fi
  rm -f "$lock"
fi

exec /opt/homebrew/bin/aerospace focus \
  --boundaries all-monitors-outer-frame \
  --boundaries-action wrap-around-all-monitors "$direction"
