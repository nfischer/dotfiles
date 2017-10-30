#!/bin/bash

IFS='
'

readonly RED='\033[1;31m'
readonly GREEN='\033[1;32m'
readonly YELLOW='\033[1;33m'
readonly BLUE='\033[1;34m'
readonly WHITE='\033[1;37m'
readonly NORM='\033[0m'

yellow() {
  echo -e "${YELLOW}$1${NORM}"
}

blue() {
  echo -e "${BLUE}$1${NORM}"
}

red() {
  echo -e "${RED}$1${NORM}"
}

green() {
  echo -e "${GREEN}$1${NORM}"
}

white() {
  echo -e "${WHITE}$1${NORM}"
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
      echo "$(green '+') Installed ${k}" ||
      echo "$(red '+') Error: could not install ${k}"
  elif [ "$(readlink "${linkName}")" == "dotfiles/${k}" ]; then
    echo "$(blue '-') ${k} already installed"
  elif [ ! -L "${linkName}" ]; then
    echo "$(yellow '?') Warning: ${k} is not a symlink"
  else
    echo "$(red 'X') Error: ${k} does not point to dotfiles/"
  fi
done

echo ''
white 'Remember to install npm packages'
