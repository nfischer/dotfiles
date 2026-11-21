#!/bin/bash

main() {
  local -a fnames="$@"
  if [ -z "${fnames[@]}" ]; then
    echo "Usage: must specify one or more HEIC/HEIF image files" >&2
    return 1
  fi

  local fname
  local new_fname
  for fname in "${fnames[@]}"; do
    new_fname="${fname%%.*}"
    if [[ "${fname}" == *.HEIC ]] || [[ "${fname}" == *.heic ]]; then
      new_fname="${new_fname}.jpg"
      heif-convert -q 100 "${fname}" "${new_fname}"
    else
      echo "Unknown file type: ${fname}" >&2
      return 2
    fi
  done
}

main "$@"
