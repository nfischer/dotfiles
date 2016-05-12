#!/bin/bash

# Update all bundled vim plugins asynchronously

BUNDLE_PATH="$HOME/.vim/bundle"

declare -a pids
declare -a plugins

for dir in ${BUNDLE_PATH}/*/; do
  if [[ -d "${dir}" ]]; then
    plugin="${dir##${BUNDLE_PATH}/}"
    plugin="${plugin%/}"
    echo "Downloading ${plugin}"
    (
      git -C "${dir}" pull &&
      git -C "${dir}" submodule update --init --recursive
    ) &>/dev/null &
    pids+=($!)
    plugins+=(${dir})
  fi
done

ret=0
# Wait for processes to finish
for k in ${!pids[@]}; do
  plugin_path="${plugins[k]}"
  plugin="${plugin_path##${BUNDLE_PATH}/}"
  plugin="${plugin%/}"
  wait ${pids[k]}
  rval=$?
  if [[ $rval -eq 0 ]]; then
    echo "Success: ${plugin} is up to date!"
  else
    echo -en "\033[1;31m"
    echo "Error updating ${plugin}" >&2
    echo -en "\033[0m"
    ret=rval
  fi
done

echo "Your plugins have been updated"
exit ${ret}
