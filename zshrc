# ===============================================================
# Start tmux by default {{{
# ===============================================================

if type tmux &>/dev/null; then
  if [[ -z "$TMUX" ]]; then
    # We're not running tmux, so it's safe to start it
    exec tmux
  fi
fi

# }}}
# ===============================================================
# Functions {{{
# ===============================================================

safe_add_path() # should only be used to dynamically add to the path
{
  case ":$PATH:" in
    *":$1:"*) ;; # do nothing, it's already there
    *) PATH="$PATH:$1";;
  esac
}

# }}}
# ===============================================================
# npm set prefix {{{
# ===============================================================

({ # Do this in the background, please
  myPrefix="$HOME/.npm-global"
  if [ "$(npm config get prefix)" != "${myPrefix}" ]; then
    npm config set prefix "${myPrefix}"
  fi
} &>/dev/null & )

# }}}
# ===============================================================
# Environmental variables {{{
# ===============================================================

export PATH="/usr/local/sbin"
PATH="$PATH:/usr/local/bin"
PATH="$PATH:/usr/sbin"
PATH="$PATH:/usr/bin"
PATH="$PATH:/sbin"
PATH="$PATH:/bin"
PATH="$PATH:/usr/games"
PATH="$PATH:/usr/local/games"
PATH="$PATH:$HOME/bin"
PATH="$PATH:$HOME/.npm-global/bin"
PATH="$PATH:/usr/local/go/bin"

# TODO(nate): do I need this one...
fpath=($fpath "$HOME/bin")

autoload -U promptinit; promptinit

# }}}
# ===============================================================
# Zplug {{{
# ===============================================================

source ~/.zplug/init.zsh

zplug 'denysdovhan/spaceship-zsh-theme', use:spaceship.zsh, from:github, as:theme
zplug 'lib/completion',       from:oh-my-zsh
zplug 'lib/directories',      from:oh-my-zsh
zplug 'lib/functions',        from:oh-my-zsh
zplug 'lib/history',          from:oh-my-zsh
zplug 'lib/key-bindings',     from:oh-my-zsh
zplug 'lib/nvm',              from:oh-my-zsh
zplug 'lib/spectrum',         from:oh-my-zsh
zplug 'lib/termsupport',      from:oh-my-zsh
zplug 'lib/theme-and-appearance',  from:oh-my-zsh
zplug 'plugins/command-not-found', from:oh-my-zsh
zplug 'plugins/git',          from:oh-my-zsh
zplug 'plugins/git-extras',   from:oh-my-zsh
zplug 'plugins/go',           from:oh-my-zsh
zplug 'plugins/npm',          from:oh-my-zsh
zplug 'plugins/nvm',          from:oh-my-zsh
zplug 'plugins/z',            from:oh-my-zsh
zplug 'supercrabtree/k'
zplug 'zsh-users/zsh-syntax-highlighting',        defer:2
zplug '~/programming/crystal-zsh', from:local

# zplug 'plugins/safe-paste',   from:oh-my-zsh

zplug load

# }}}
# ===============================================================
# Plugin configuration {{{
# ===============================================================

# TODO(nate): or do I need this one instead?
fpath=($fpath "$HOME/bin")

# ZSH_HIGHLIGHT_HIGHLIGHTERS=(main brackets pattern cursor)

# User configuration

# setopt no_inc_append_history
# setopt no_share_history

# export MANPATH="/usr/local/man:$MANPATH"

# You may need to manually set your language environment
export LANG=en_US.UTF-8

# Preferred editor for local and remote sessions
if [[ -n $SSH_CONNECTION ]]; then
  export EDITOR='nvim'
else
  export EDITOR='nvim'
fi

# ssh
# export SSH_KEY_PATH="~/.ssh/dsa_id"

# }}}
# ===============================================================
# nvm {{{
# ===============================================================

export NVM_DIR="$HOME/.nvm"
[ -s "$NVM_DIR/nvm.sh" ] && . "$NVM_DIR/nvm.sh"  # This loads nvm

# }}}
# ===============================================================
# Aliases {{{
# ===============================================================

[ -f ~/.shell_aliases ] && source ~/.shell_aliases

alias reload='. ~/.zshrc && echo "reloading zshrc"'
alias open=open_command
alias gh='git head'

# }}}
# ===============================================================
# Other goodies {{{
# ===============================================================

# Completion for nan command
compdef nan=man

setopt auto_cd

# Local zshrc
if [ -f "$HOME/.local.zshrc" ]; then
  source "$HOME/.local.zshrc"
fi
# }}}
# ===============================================================
