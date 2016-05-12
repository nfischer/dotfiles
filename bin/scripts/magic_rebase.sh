#!/bin/bash

# Magically rebase a ShellJS PR!

function magic_rebase() {
  if [ ! -z "$1" ]; then
    cd "$1"
  fi
  [ -d node_modules/ ] && cd node_modules/

  # Just choose the first directory we find that isn't hidden
  dir=$(ls -d */ | head)
  [ -d "${dir}" ] && cd "${dir}"

  git fetch origin master:master && git rebase master
  if [ $? != 0 ]; then
    echo "There was an error rebasing" >&2
    return 1
  fi

  npm install && npm test
  if [ $? != 0 ]; then
    echo "There was an error running 'npm test'" >&2
    return 2
  fi

  cur_branch=$(git rev-parse --abbrev-ref HEAD | tr -d '\n')
  if [ -z "${cur_branch}" ]; then
    echo "Can't find current branch" >&2
    return 3
  fi
  echo "Please check your work and run:"
  echo "git push -f origin ${cur_branch}"
}
