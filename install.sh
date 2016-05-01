#!/bin/bash

old_IFS=${IFS}
IFS='
'

cd $(dirname $0) # make sure we're in the correct directory
for k in `ls .`; do
  if [ "$k" != "install.sh" ]; then # skip over this script of course
    if [ -f "../.${k}" ]; then
      if [ "$(readlink ../.${k})" == "dotfiles/${k}" ]; then
        echo "${k} already installed"
      else
        echo "- Warning: ${k} does not point to dotfiles/"
      fi
    else
      ln -s "dotfiles/${k}" "../.${k}" && echo "+ Installed ${k}"
    fi
  fi
done
