[[ -n $ZSHRC_PROFILE ]] && zmodload zsh/zprof

autoload -Uz compinit
compinit

FZF_COLORS="fg:#f2f4f8,bg:-1,hl:#78a9ff,fg+:#f2f4f8,bg+:#353535,hl+:#3ddbd9"

source /opt/homebrew/share/fzf-tab/fzf-tab.zsh
zstyle ':completion:*' menu no
zstyle ':fzf-tab:*' fzf-flags --color=$FZF_COLORS
zstyle ':fzf-tab:complete:cd:*' fzf-preview 'eza -1 --color=always --icons=always $realpath'
zstyle ':fzf-tab:complete:*:*' fzf-preview 'bat --color=always --style=numbers $realpath 2>/dev/null || eza -1 --color=always --icons=always $realpath 2>/dev/null'

source /opt/homebrew/share/zsh-autosuggestions/zsh-autosuggestions.zsh
source /opt/homebrew/share/zsh-syntax-highlighting/zsh-syntax-highlighting.zsh

HISTFILE="$XDG_STATE_HOME/zsh/history"
SAVEHIST=1000
HISTSIZE=999
setopt share_history
setopt hist_expire_dups_first
setopt hist_ignore_dups
setopt hist_verify
setopt hist_ignore_space

bindkey '^[[A' history-search-backward
bindkey '^[[B' history-search-forward

sudo-command-line() {
  [[ -z $BUFFER ]] && LBUFFER="$(fc -ln -1)"
  if [[ $BUFFER == sudo\ * ]]; then
    LBUFFER="${LBUFFER#sudo }"
  else
    LBUFFER="sudo $LBUFFER"
  fi
}
zle -N sudo-command-line
bindkey '\e\e' sudo-command-line

export LS_COLORS="di=38;2;120;169;255:ln=38;2;61;219;217:ex=38;2;37;190;106:so=38;2;238;83;150:pi=38;2;190;149;255:bd=38;2;51;177;255:cd=38;2;51;177;255:or=38;2;238;83;150:mi=38;2;238;83;150:*.md=38;2;190;149;255:*.json=38;2;255;126;182:*.yaml=38;2;255;126;182:*.yml=38;2;255;126;182:*.toml=38;2;255;126;182:*.lua=38;2;82;189;255:*.go=38;2;8;189;186:*.py=38;2;51;177;255:*.rs=38;2;255;126;182:*.js=38;2;190;149;255:*.ts=38;2;120;169;255:*.tsx=38;2;120;169;255:*.nix=38;2;82;189;255:*.sh=38;2;37;190;106:*.tar=38;2;238;83;150:*.gz=38;2;238;83;150:*.zip=38;2;238;83;150:*.png=38;2;255;126;182:*.jpg=38;2;255;126;182:*.svg=38;2;255;126;182:*.pdf=38;2;238;83;150"

alias ls="eza --icons=always"
alias ssh='TERM=xterm-256color ssh'

eval "$(starship init zsh)"

export PATH="$HOME/.local/bin:$PATH"
eval "$(/usr/libexec/path_helper)"

eval "$(direnv hook zsh)"

source <(fzf --zsh)
export FZF_DEFAULT_COMMAND="fd --type f --hidden --exclude .git"
export FZF_CTRL_T_COMMAND="$FZF_DEFAULT_COMMAND"
export FZF_ALT_C_COMMAND="fd --type d --hidden --exclude .git"
export FZF_DEFAULT_OPTS="--height 60% --layout=reverse --border --color=$FZF_COLORS,info:#be95ff,prompt:#ee5396,pointer:#ff7eb6,marker:#25be6a,spinner:#08bdba,header:#33b1ff"

export BAT_THEME="base16"

eval "$(zoxide init zsh)"

eval "$(atuin init zsh --disable-up-arrow)"

function y() {
  local tmp cwd
  tmp="$(mktemp -t yazi-cwd.XXXXXX)"
  yazi "$@" --cwd-file="$tmp"
  if cwd="$(command cat -- "$tmp")" && [ -n "$cwd" ] && [ "$cwd" != "$PWD" ]; then
    builtin cd -- "$cwd"
  fi
  rm -f -- "$tmp"
}

source <(kubectl completion zsh)
compdef kubecolor=kubectl
alias kubectl="kubecolor"
alias k="kubecolor"

[ -f ~/.zshrc.local ] && source ~/.zshrc.local

[[ -n $ZSHRC_PROFILE ]] && zprof
