#!/bin/bash

convert_file() {
  local heic_file="$1"
  local jpg_file="${heic_file/.heic/.jpg}"
  local jpg_file="${jpg_file/.HEIC/.jpg}"
  heif-convert -q 100 "${heic_file}" "${jpg_file}" >/dev/null

  local orientation="$(exiftool '-Orientation' "${heic_file}")"
  if [[ "${orientation}" == *"Rotate 90 CW" ]]; then
    mogrify -rotate -90 "${jpg_file}"
  elif [[ "${orientation}" == *"Rotate 270 CW" ]]; then
    mogrify -rotate 90 "${jpg_file}"
  elif [[ "${orientation}" == *"Rotate 180" ]]; then
    mogrify -rotate 180 "${jpg_file}"
  fi

  # Copy over the 'access' and 'modify' timestamps of the original file.
  touch -r "${heic_file}" "${jpg_file}"

  echo "${heic_file} -> ${jpg_file}"
}

main() {
  local fname
  for fname in "$@"; do
    convert_file "${fname}"
  done
}

main "$@"
