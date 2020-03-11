#!/bin/sh
# ~/.profile: executed by the command interpreter for login shells.
# This file is not read by bash(1), if ~/.bash_profile or ~/.bash_login
# exists.
# see /usr/share/doc/bash/examples/startup-files for examples.
# the files are located in the bash-doc package.

# the default umask is set in /etc/profile; for setting the umask
# for ssh logins, install and configure the libpam-umask package.
#umask 022

# Only source bashrc if we're running "real" bash. Bash has a posix-compatible
# mode (`bash --posix` or `/bin/sh if symlinked to bash): don't source bashrc in
# this case. Although compatibility mode only starts after sourcing files (see
# https://tiswww.case.edu/php/chet/bash/POSIX), still don't source bashrc in
# case: this script pulls in code and sets a prompt which assumes bash shell
# extensions (not POSIX compatible).
#
# Here's what we can check:
# * "$BASH_VERSION" will legitimately have a value if sh is bash in
#   compatibility mode, so it's not useful here.
# * "$0" might report "bash" if invoked with `bash --posix`, but we still don't
#   want to source bashrc in this case.
# * "$POSIXLY_CORRECT" is only set *after* sourcing scripts, and .profile is
#   often sourced before that point. OTOH, keep this check in case we're
#   sourcing .profile explicitly.
if [ "$0" = "bash" ] && [ "$POSIXLY_CORRECT" != "y" ]; then
  # include .bashrc if it exists
  [ -f "$HOME/.bashrc" ] && . "$HOME/.bashrc"
else
  export PS1="$0 \$ "
fi
