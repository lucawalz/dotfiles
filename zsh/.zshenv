export XDG_CONFIG_HOME="$HOME/.config"
export XDG_DATA_HOME="$HOME/.local/share"
export XDG_STATE_HOME="$HOME/.local/state"
export XDG_CACHE_HOME="$HOME/.cache"

mkdir -p "$XDG_STATE_HOME"/{zsh,less,node,python} "$XDG_DATA_HOME"/mysql "$XDG_CACHE_HOME"/zsh

typeset -U path PATH
path=("$HOME/.local/bin" $path)

export LESSHISTFILE="$XDG_STATE_HOME/less/history"
export NODE_REPL_HISTORY="$XDG_STATE_HOME/node/repl_history"
export PYTHON_HISTORY="$XDG_STATE_HOME/python/history"
export MYSQL_HISTFILE="$XDG_DATA_HOME/mysql/history"
export GOPATH="$XDG_DATA_HOME/go"
export DOCKER_CONFIG="$XDG_CONFIG_HOME/docker"
export NPM_CONFIG_CACHE="$XDG_CACHE_HOME/npm"
