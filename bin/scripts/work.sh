#!/bin/bash

# Do not put a trailing slash on these values! These can be override in .zshrc
WORK_ROOTS=("$HOME/programming")
WORK_TARGETS=("$HOME/packages" "$HOME/bin" "$HOME/.vim" "$HOME/dotfiles")

work_helper() {
  local dir="$1"
  local root
  local target
  local target_name

  for target in "${WORK_TARGETS[@]}"; do
    target_name="$(basename "${target}")"
    if [ "${dir}" == "${target_name}" ]; then
      cd "${target}" 2>/dev/null && return 0
    fi
  done

  for root in "${WORK_ROOTS[@]}"; do
    cd "${root}/${dir}/src" &>/dev/null && return 0
    cd "${root}/${dir}" &>/dev/null && return 0
  done
  echo "Could not find ${dir}" >&2
  return 1
}

work() {
  work_helper "$@" || return $?
  pwd
  git status -uno 2>/dev/null || ls
}
