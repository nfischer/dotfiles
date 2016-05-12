#!/bin/bash

# changes to directory of specified project
function work() {
  local specific_case
  function specific_case() {
    local root="$1"
    local proj_dir="$2"

    local no_match
    function no_match() {
      cd "$1"
      echo "$2* matches no directory. Changed to $1 instead." >&2
      pwd
      ls
      return 1
    }

    local ls_output
    if [[ "${proj_dir}" == */ ]]; then # ends in a slash
      ls_output=$(ls -d "${root}${proj_dir}" 2>/dev/null)
    else # not absolute
      ls_output=$(ls -d "${root}${proj_dir}"*/ 2>/dev/null)
    fi

    if [ -z "${ls_output}" ]; then
      no_match "${root}" "${proj_dir}"
      return $?
    fi
    local dir_name=$(echo "${ls_output}" | head -n 1)

    echo "${dir_name}"
    cd "${dir_name}" 2>/dev/null || no_match "${root}" "${proj_dir}" || return $?

    # change to src directory, since I normally want that one
    cd src/ &>/dev/null || true

    # git status if it is a git repo
    git status 2>/dev/null || true

    return 0
  }

  local proj_dir="$1"
  local root="$HOME/programming/"
  if [ ! -d "${root}" ]; then
    echo -n "Error: ${root} is not a directory. Please modify $0 to " >&2
    echo "update this." >&2
    return 2
  fi

  if [ $# -gt 1 ]; then
    echo "Too many arguments" >&2
    return 1
  fi

  case "${proj_dir}" in
    "")
      cd "${root}"
      ;;
    npm)
      cd ~/.npm-global/lib/node_modules
      ;;
    bundle)
      cd ~/.vim/bundle
      ;;
    vim)
      cd ~/.vim
      ;;
    bin)
      cd ~/bin
      ;;
    *)
      specific_case "${root}" "${proj_dir}"
      return $?
      ;;
  esac
  pwd
  ls
  return 0
}
