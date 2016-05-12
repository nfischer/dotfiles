#!/bin/bash

# Change to media/flash drives folder
# Should work under Linux, Mac OS X, and Cygwin

function media() {
  #                      CYGWIN_NT-6.1
  local readonly SYSINFO="$(uname -s)"
  case ${SYSINFO} in
    "CYGWIN_NT-6.1")
      cd /cygdrive/
      ;;
    Linux)
      cd /media/
      local readonly VERSION
      VERSION="$(cat /etc/os-release | grep '^PRETTY_NAME' | sed 's/PRETTY_NAME="\(.*\)"/\1/')"
      if [[ "${VERSION}" > "Ubuntu 13" ]]; then
          cd "$USER"
      fi
      ;;
    Darwin)
      cd /Volumes/
      ;;
    *)
      echo "Could not detect system." >&2
      return 1
      ;;
  esac
  return $?
}
