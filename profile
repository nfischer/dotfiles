#!/bin/sh
# ~/.profile: executed by the command interpreter for login shells.
# This file is not read by bash(1), if ~/.bash_profile or ~/.bash_login
# exists.
# see /usr/share/doc/bash/examples/startup-files for examples.
# the files are located in the bash-doc package.

# the default umask is set in /etc/profile; for setting the umask
# for ssh logins, install and configure the libpam-umask package.
#umask 022

safe_add_path()
{
  case ":$PATH:" in
    *":$1:"*) ;; # do nothing, it's already there
    *) PATH="$PATH:$1";;
  esac
}

# if running bash
if [ -n "$BASH_VERSION" ]; then
  # include .bashrc if it exists
  [ -f "$HOME/.bashrc" ] && . "$HOME/.bashrc"
fi

# set PATH so it includes user's private bin if it exists
[ -d "$HOME/bin" ] && safe_add_path "$HOME/bin"

# set PATH so it includes npm packages
# npm_prefix="$(npm config get prefix)"
npm_prefix="$HOME/.npm-global"
npm_bin="${npm_prefix}/bin"
if [ -d "${npm_bin}" ] ; then
  safe_add_path "${npm_bin}"
  export NODE_PATH="${npm_prefix}/lib/node_modules"
fi
unset npm_prefix
unset npm_bin

# # Start Dropbox daemon (needs &)
# ~/.dropbox-dist/dropboxd &

export OLD_JAVA_HOME=$JAVA_HOME
export JAVA_HOME=/usr/lib/jvm/java-8-openjdk-amd64/jre
