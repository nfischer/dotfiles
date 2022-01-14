#!/bin/bash

# A simple script to do replicate a backup on another drive
# Usage: replicate-backup {path/to/backup/folder} {path/to/other/drive}

set -e

original_backup="$1"
original_backup="${original_backup%%/}" # remove trailing slash
other_drive="$2"
other_drive="${other_drive%%/}" # remove trailing slash
if [ -z "${original_backup}" ] || [ -z "${other_drive}" ]; then
  echo "Please pass 2 args:" >&2
  echo "  replicate-backup {path/to/backup/folder} {path/to/other/drive}" >&2
  exit 1
fi
if [ ! -d "${original_backup}" ] ; then
  echo "Original backup (1st arg) must exist!" >&2
  exit 2
fi
if [ ! -d "${other_drive}" ] ; then
  echo "Other drive (2nd arg) must exist!" >&2
  exit 2
fi

readonly backup_folder_name="${original_backup##*/}"
readonly output_dir="${other_drive}/${backup_folder_name}/"

# Must have trailing slash
echo "Copy '${original_backup}' into '${output_dir}'"
read -p "Press enter to continue (ctrl-c to quit)" dummyvar

# If this fails, it indicates some bad state
mkdir "${output_dir}"

rsync --info=progress2 -av --exclude-from="$EXCLUDE_LIST" \
  "$original_backup/" \
  "${output_dir}"

echo ""
cat "${output_dir}/BACKUP_METADATA.txt"

echo ""
echo "Done"
