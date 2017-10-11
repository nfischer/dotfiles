# ===============================================================
# Start tmux by default {{{
# ===============================================================

if type tmux &>/dev/null; then
  if [[ -z "$TMUX" ]]; then
    # We're not running tmux, so it's safe to start it
    exec tmux -2
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
# Miscellaneous {{{
# ===============================================================

HIST_STAMPS="mm/dd/yyyy" # Do not change this, or else history breaks

# }}}
# ===============================================================
# Environmental variables {{{
# ===============================================================

NPM_PREFIX="$HOME/.npm-global"

export PATH="/usr/local/sbin"
PATH="$PATH:/usr/local/bin"
PATH="$PATH:/usr/sbin"
PATH="$PATH:/usr/bin"
PATH="$PATH:/sbin"
PATH="$PATH:/bin"
PATH="$PATH:/usr/games"
PATH="$PATH:/usr/local/games"
PATH="$PATH:$HOME/bin"
PATH="$PATH:$HOME/local-bin"
PATH="$PATH:$NPM_PREFIX/bin"
PATH="$PATH:/usr/local/go/bin"

export NODE_PATH="$NPM_PREFIX/lib/node_modules"

export LESS=-Ri # show colors and smartcase search

export JAVA_HOME=/usr/lib/jvm/java-8-openjdk-amd64/jre

# Set language for en_US.UTF-8
# If this causes issues, try these steps:
#
#   $ dpkg -l locales (check that "ii" is next to locales)
#   $ aptitude install locales (if not installed)
#   $ dpkg-reconfigure locales (press <space> for en_US.UTF-8)
#
export LC_ALL=en_US.UTF-8
export LANG=en_US.UTF-8
export LANGUAGE=en_US.UTF-8

# Preferred editor for local and remote sessions
export EDITOR="$(sh -c 'which nvim || which vim || which vi')"

# ssh
# export SSH_KEY_PATH="~/.ssh/dsa_id"

# TODO(nfischer): move this somewhere else
autoload -U promptinit; promptinit

# }}}
# ===============================================================
# Extra fpath modifications {{{
# ===============================================================

fpath=($fpath "$HOME/bin")
fpath=($fpath "$HOME/bin/scripts")
fpath=($fpath "$HOME/local-bin")

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
zplug 'zsh-users/zsh-autosuggestions'
zplug 'zsh-users/zsh-syntax-highlighting',        defer:2
zplug '~/programming/crystal-zsh', from:local

# zplug 'plugins/safe-paste',   from:oh-my-zsh

zplug load

# }}}
# ===============================================================
# Plugin configuration {{{
# ===============================================================

SPACESHIP_BATTERY_SHOW=false
SPACESHIP_KUBECONTEXT_SHOW=false

##
# Override the settings for zsh-autosuggestions. I want ➜ to move forward one
# char in the suggestion, not to accept the entire thing. I prefer ctrl-e to
# accept the full suggestion. See [Github source code](https://goo.gl/SXLi5V).

ZSH_AUTOSUGGEST_ACCEPT_WIDGETS=(
  end-of-line
  vi-add-eol
  vi-end-of-line
)

ZSH_AUTOSUGGEST_PARTIAL_ACCEPT_WIDGETS=(
  forward-char
  forward-word
  vi-forward-blank-word
  vi-forward-blank-word-end
  vi-forward-char
  vi-forward-word
  vi-forward-word-end
)

# ZSH_HIGHLIGHT_HIGHLIGHTERS=(main brackets pattern cursor)

# User configuration

# }}}
# ===============================================================
# zsh settings {{{
# ===============================================================

setopt auto_cd

# setopt no_inc_append_history
# setopt no_share_history

# }}}
# ===============================================================
# zsh bindings {{{
# ===============================================================

# Make ctrl-u work like it does for bash
bindkey '^u' backward-kill-line

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

# Suffix aliases
alias -s c="$EDITOR"
alias -s cc="$EDITOR"
alias -s cpp="$EDITOR"
alias -s h="$EDITOR"
alias -s java="$EDITOR"
alias -s md="$EDITOR"
alias -s txt="$EDITOR"
alias -s vim="$EDITOR"
alias -s xml="$EDITOR"

# }}}
# ===============================================================
# Other goodies {{{
# ===============================================================

# Completion for nan command
compdef nan=man

# }}}
# ===============================================================
# Local zshrc {{{
# ===============================================================

if [ -f "$HOME/.zshrc.local" ]; then
  source "$HOME/.zshrc.local"
fi

# }}}
# ===============================================================
