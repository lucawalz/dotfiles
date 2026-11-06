#!/usr/bin/env bash
set -u

PROJECTS_DIR=$HOME/code
FZF_COLORS="fg:#f2f4f8,bg:-1,hl:#78a9ff,fg+:#f2f4f8,bg+:#353535,hl+:#3ddbd9"

pick=$({
  sesh list -t
  fd -d 1 -t d . "$PROJECTS_DIR" | sed -e "s|^$HOME|~|" -e 's|/$||'
} | fzf --no-sort --prompt "sesh> " --color="$FZF_COLORS") || exit 0

exec sesh connect "${pick/#\~/$HOME}"
