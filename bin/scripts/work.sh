#!/bin/bash

WORK_ROOTS=("$HOME/programming")
WORK_TARGETS=("$HOME/.vim" "$HOME/bin" "$HOME/dotfiles")
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
    cd "${root}/${dir}" &>/dev/null && return 0
  done
  return 1
}

work() {
  work_helper "$@"
  ret=$?

  if [ $? == 0 ]; then
    pwd
    git status 2>/dev/null
  fi
  return $ret
}

_work() {
  local -a _1st_arguments
  local target
  local root
  local file

  for target in "${WORK_TARGETS[@]}"; do
    _1st_arguments=(${_1st_arguments} "$(basename "${target}")")
  done

  for root in "${WORK_ROOTS[@]}"; do
    for file in "${root}/"*/; do
      _1st_arguments=(${_1st_arguments} "$(basename "${file}")")
    done
  done

  _arguments \
    '*:: :->subcmds' && return 0

  if (( CURRENT == 1 )); then
    _describe -t commands "work subcommand" _1st_arguments
    return
  fi
}

compdef _work work
