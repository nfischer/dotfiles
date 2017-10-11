#!/bin/bash

# ===============================================================
# These variables can be overridden in .bashrc/.zshrc {{{
# ===============================================================

# The directories which contain projects. The subdirectories of each root will
# be valid arguments.
WORK_ROOTS=("$HOME/programming")

# One-off directories which should also be valid arguments.
WORK_TARGETS=("$HOME/packages" "$HOME/bin" "$HOME/.vim" "$HOME/dotfiles")

# }}}
# ===============================================================

remove_trailing_slash() {
  echo "${1%/}"
}

work_helper() {
  local dir="$(remove_trailing_slash "$1")"
  local root
  local target
  local target_name
  local base_target_name

  for target in "${WORK_TARGETS[@]}"; do
    base_target_name="$(basename "${target}")"
    target_name="$(remove_trailing_slash "${base_target_name}")"
    if [ "${dir}" == "${target_name}" ]; then
      cd "${target}" 2>/dev/null && return 0
    fi
  done

  for root in "${WORK_ROOTS[@]}"; do
    root="$(remove_trailing_slash "${root}")"
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
