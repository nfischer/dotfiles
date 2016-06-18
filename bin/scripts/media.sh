#!/bin/bash

# Change to media/flash drives folder
# Should work under Linux, Mac OS X, and Cygwin

function media() {
  local SYSINFO
  SYSINFO="$(uname -s)"
  case ${SYSINFO} in
    CYGWIN*)
      dir="/cygdrive/"
      ;;
    Linux)
      local VERSION
      VERSION="$(grep '^PRETTY_NAME' /etc/os-release | sed 's/PRETTY_NAME="\(.*\)"/\1/')"
      if [[ "${VERSION}" > "Ubuntu 13" ]]; then
        dir="/media/$USER/"
      else
        dir="/media/"
      fi
      ;;
    Darwin)
      dir="/Volumes/"
      ;;
    *)
      echo "Could not detect system." >&2
      return 1
      ;;
  esac
  cd "${dir}"
  return $?
}
