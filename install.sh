#!/bin/bash

IFS='
'

readonly RED='\e[1;31m'
readonly GREEN='\e[1;32m'
readonly YELLOW='\e[1;33m'
readonly BLUE='\e[1;34m'
readonly WHITE='\e[1;37m'
readonly NORM='\e[0m'

cd "$(dirname "$0")" # make sure we're in the correct directory
for k in *; do
  if [ "${k}" != "install.sh" ] && [ "${k}" != "new_comp.sh" ]; then # skip over these scripts
    if [ "${k}" == "bin" ]; then
      linkName="../bin"
    else
      linkName="../.${k}"
    fi
    if [ -e "${linkName}" ]; then
      if [ "$(readlink "${linkName}")" == "dotfiles/${k}" ]; then
        echo -e "${BLUE}-${NORM} ${k} already installed"
      elif [ ! -L "${linkName}" ]; then
        echo -e "${YELLOW}?${NORM} Warning: ${k} is not a symlink"
      else
        echo -e "${RED}X${NORM} Error: ${k} does not point to dotfiles/"
      fi
    else
      ln -s "dotfiles/${k}" "${linkName}" && echo -e "${GREEN}+${NORM} Installed ${k}"
    fi
  fi
done

# Perform npm install for bin/
echo ""
echo "Installing npm packages"
cd bin/
npm install
