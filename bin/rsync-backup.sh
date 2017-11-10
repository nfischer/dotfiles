#!/bin/bash

# Do a simple backup
# Usage: rsync-backup /path/to/external/drive/new-folder

set -e

# Set this to the name of external drive
readonly DRIVE_NAME="WDElements"
readonly EXCLUDE_LIST="$HOME/backup-exclude-list.txt"

readonly host="$(hostname)"
readonly date="$(date '+%m-%d-%y')"
readonly output_dir="/media/$USER/$DRIVE_NAME/${host}-${date}/"

# Must have trailing slash
echo "Backup up into '${output_dir}'"
read -p "Press enter to coninue (ctrl-c to quit)" dummyvar

# If this fails, it indicates some bad state
mkdir "${output_dir}"

rsync --info=progress2 -av --exclude-from="$EXCLUDE_LIST" \
  "$HOME/" \
  "${output_dir}"
