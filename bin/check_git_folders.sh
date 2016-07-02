#!/bin/bash

declare -a gitFolders
declare -a foldersWithChanges

readarray -t gitFolders <<<"$(find ~ -type d -name .git 2>/dev/null)"

cd ~
for dir in "${gitFolders[@]}"; do
  cd "$(dirname "$dir")"
  echo "<$dir>"
  pwd
  # {
  #   cd "$(dirname "$dir")" &&
  #   git diff --quiet HEAD --
  # } || echo "$? ${dir}"
done

