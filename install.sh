#!/bin/bash

IFS='
'

readonly RED='\e[1;31m'
readonly GREEN='\e[1;32m'
readonly YELLOW='\e[1;33m'
readonly BLUE='\e[1;34m'
readonly WHITE='\e[1;37m'
readonly NORM='\e[0m'

yellow() {
  echo "${YELLOW}$1${NORM}"
}

blue() {
  echo "${BLUE}$1${NORM}"
}

red() {
  echo "${RED}$1${NORM}"
}

green() {
  echo "${GREEN}$1${NORM}"
}

white() {
  echo "${WHITE}$1${NORM}"
}

cd "$(dirname "$0")" # make sure we're in the correct directory
files_to_skip=(install.sh new_comp.sh README.md LICENSE)
for k in *; do
  if [[ "${files_to_skip[@]}" == *"${k}"* ]]; then
    continue # these don't count as real dotfiles, so don't install them
  fi

  if [ "${k}" == "bin" ]; then
    # Special case
    linkName="../bin"
  else
    linkName="../.${k}"
  fi

  if [ ! -e "${linkName}" ]; then
    ln -s "dotfiles/${k}" "${linkName}" &&
      echo -e "$(green '+') Installed ${k}" ||
      echo -e "$(red '+') Error: could not install ${k}"
  elif [ "$(readlink "${linkName}")" == "dotfiles/${k}" ]; then
    echo -e "$(blue '-') ${k} already installed"
  elif [ ! -L "${linkName}" ]; then
    echo -e "$(yellow '?') Warning: ${k} is not a symlink"
  else
    echo -e "$(red 'X') Error: ${k} does not point to dotfiles/"
  fi
done

# Perform npm install for bin/
if which npm &>/dev/null; then
  echo -e "\n$(white 'Installing npm packages')"
  cd bin/
  npm install
fi
