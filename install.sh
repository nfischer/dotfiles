#!/bin/bash

old_IFS=${IFS}
IFS='
'

cd $(dirname $0) # make sure we're in the correct directory
for k in `ls .`; do
  if [ "${k}" != "install.sh" ]; then # skip over this script of course
    if [ "${k}" == "bin" ]; then
      linkName="../bin"
    else
      linkName="../.${k}"
    fi
    if [ -e "${linkName}" ]; then
      if [ "$(readlink ${linkName})" == "dotfiles/${k}" ]; then
        echo "${k} already installed"
      else
        echo "- Warning: ${k} does not point to dotfiles/"
      fi
    else
      ln -s "dotfiles/${k}" "${linkName}" && echo "+ Installed ${k}"
    fi
  fi
done

# Perform npm install for bin/
echo ""
echo "Installing npm packages"
cd bin/
npm install
