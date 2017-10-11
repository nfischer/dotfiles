#!/bin/bash

# If not running interactively, don't do anything
case $- in
  *i*) ;;
    *) return;;
esac

# ===============================================================
# Shell options (shopt) {{{
# ===============================================================

# append to the history file, don't overwrite it
shopt -s histappend

# check the window size after each command and, if necessary,
# update the values of LINES and COLUMNS.
shopt -s checkwinsize

# If set, the pattern "**" used in a pathname expansion context will
# match all files and zero or more directories and subdirectories.
shopt -s globstar

# }}}
# ===============================================================
# History {{{
# ===============================================================

# don't put duplicate lines or lines starting with space in the history.
# See bash(1) for more options
HISTCONTROL=ignoreboth

# for setting history length see HISTSIZE and HISTFILESIZE in bash(1)
HISTSIZE=1000
HISTFILESIZE=2000

# }}}
# ===============================================================
# Functions {{{
# ===============================================================

function setPS1() {
  local E_RED='\[\e[1\;31m\]'     # semicolon is escaped
  local E_GREEN='\[\e[1\;32m\]'   # semicolon is escaped
  # local RED='\[\e[1;31m\]'
  # local GREEN='\[\e[1;32m\]'
  local YELLOW='\[\e[1;33m\]'
  local BLUE='\[\e[1;34m\]'
  local WHITE='\[\e[1;37m\]'
  local REG='\[\e[0m\]'

  PS1="\n\$(if [[ \$? == 0 ]]; then echo ${E_GREEN}; else echo ${E_RED}; fi)\u@\h ${BLUE}\w"
  PS1="${PS1}\$(if [ ! -z \${VIRTUAL_ENV} ]; then echo \"${WHITE} (\${VIRTUAL_ENV##*/})\"; fi)"
  if type __git_ps1 &>/dev/null; then
    # If git is installed, then we can show prompt
    # Note: this is only determined at shell initialization, not for
    # every creation of the prompt, so it's still efficient
    PS1="${PS1}\$(__git_ps1 '${YELLOW} [%s]')"
  fi
  PS1="${PS1}\n${WHITE}\$ ${REG}"
}

# }}}
# ===============================================================
# Miscellaneous {{{
# ===============================================================

# make less more friendly for non-text input files, see lesspipe(1)
[ -x /usr/bin/lesspipe ] && eval "$(SHELL=/bin/sh lesspipe)"

# set variable identifying the chroot you work in (used in the prompt below)
if [ -z "${debian_chroot:-}" ] && [ -r /etc/debian_chroot ]; then
  debian_chroot=$(cat /etc/debian_chroot)
fi

# set a fancy prompt (non-color, unless we know we "want" color)
case "$TERM" in
  xterm-color) color_prompt=yes;;
esac

# enable programmable completion features (you don't need to enable
# this, if it's already enabled in /etc/bash.bashrc and /etc/profile
# sources /etc/bash.bashrc).
if ! shopt -oq posix; then
  if [ -f /usr/share/bash-completion/bash_completion ]; then
  . /usr/share/bash-completion/bash_completion
  elif [ -f /etc/bash_completion ]; then
  . /etc/bash_completion
  fi
fi
# TODO(ntfschr) : The above section occasionally fails if bashrc has been
# sourced a lot

# }}}
# ===============================================================
# Aliases {{{
# ===============================================================

[ -f ~/.shell_aliases ] && source ~/.shell_aliases

alias reload='. ~/.bashrc && echo "reloading bashrc"'

# }}}
# ===============================================================
# Environmental variables {{{
# ===============================================================

# export TERM='xterm-256color' # Necessary for tmux

# }}}
# ===============================================================
# Cygwin specific {{{
# ===============================================================

if [ "$(uname -s)" == "CYGWIN_NT-6.1" ]; then
  alias ls='ls --color=auto'
  alias sudo='echo -e "\n\tNo sudo on cygwin!\n";'
  alias root='cd /cygdrive/c/'
  alias vi='/usr/bin/vim'
  alias umount='echo "umount does not work properly on Cygwin"'
  alias open='cygstart'
fi

setPS1 # now we set the prompt

# Prevent evil ctrl-s terminal behavior
stty -ixon

# }}}
# ===============================================================
# Local bashrc {{{
# ===============================================================

if [ -f "$HOME/.bashrc.local" ]; then
  source "$HOME/.bashrc.local"
fi

# }}}
# ===============================================================
