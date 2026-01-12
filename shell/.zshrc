# Enable autocomplete
autoload -Uz compinit
compinit

# Zsh plugins
source /opt/homebrew/share/zsh-autosuggestions/zsh-autosuggestions.zsh
source /opt/homebrew/share/zsh-syntax-highlighting/zsh-syntax-highlighting.zsh

# Basic PATH setup
export PATH="/opt/homebrew/opt/postgresql@17/bin:$PATH"
export PATH="/Applications/Ollama.app/Contents/Resources:$PATH"
export PATH="$HOME/agenix:$PATH"
export SOPS_AGE_KEY_FILE=~/.config/sops/age/keys.txt

# history setup
HISTFILE=$HOME/.zhistory
SAVEHIST=1000
HISTSIZE=999
setopt share_history
setopt hist_expire_dups_first
setopt hist_ignore_dups
setopt hist_verify

bindkey '^[[A' history-search-backward
bindkey '^[[B' history-search-forward

# File colors
export LS_COLORS="$(vivid generate vscode)"

alias ls="eza --icons=always"

eval "$(zoxide init zsh)"

alias cd="z"

# Added by Antigravity
export PATH="/Users/luca/.antigravity/antigravity/bin:$PATH"

#starship
eval "$(starship init zsh)"