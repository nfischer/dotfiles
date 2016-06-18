#!/bin/bash

VIM_D="${HOME}/.vim"
SWAP_D="tmp"

old_IFS=${IFS}
IFS='
'

files=($(ls -A "${VIM_D}/${SWAP_D}/"))

status=0
if [[ ${#files[@]} -ne 0 ]]; then
  echo "Resolve the following swap files:"
  echo "${files[@]}"
  status=1
fi
IFS=${old_IFS}
exit ${status}
