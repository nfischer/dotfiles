#!/bin/bash

main() {
  local -a files=("$@")
  local file
  for file in "${files[@]}"; do
    echo "${file}"
    xdg-open "${file}" 2>/dev/null
    local response
    while true; do
      echo "What would you like to do?"
      read -p "[d]elete [r]ename [s]kip: " response
      case "${response}" in
        d)
          rm -v "${file}"
          break
          ;;
        r)
          local newName
          local absPath="$(realpath "${file}")"
          local dir="$(dirname "${absPath}")"
          read -p "New name: " newName
          mv -v "${file}" "${dir}/${newName}"
          break
          ;;
        s)
          break
          ;;
        ?)
          echo "Unknown option '${response}'" >&2
          ;;
        *)
          echo "Response must be a single character, not '${response}'" >&2
          ;;
      esac
    done
  done
}

main "$@"
