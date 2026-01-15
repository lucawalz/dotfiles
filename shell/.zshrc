# Enable autocomplete
autoload -Uz compinit
compinit

# Zsh plugins
source /opt/homebrew/share/zsh-autosuggestions/zsh-autosuggestions.zsh
source /opt/homebrew/share/zsh-syntax-highlighting/zsh-syntax-highlighting.zsh

# Add your custom PATH entries here
# export PATH="/custom/path:$PATH"

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
export LS_COLORS="$(vivid generate one-dark)"

alias ls="eza --icons=always"

eval "$(zoxide init zsh)"

alias cd="z"



#starship
eval "$(starship init zsh)"