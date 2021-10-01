#!/bin/bash

# A simple script to do a backup
# Usage: rsync-backup

set -e

# Set this to the name of external drive
readonly DRIVE_NAME="WDElements"
readonly EXCLUDE_LIST="$HOME/backup-exclude-list.txt"

readonly host="$(hostname)"
readonly date="$(date -I)"

find_drive() {
  local -a drives=($(ls "/media/$USER/"))
  if [[ "${#drives[@]}" < 1 ]]; then
    echo "Could not find any drives at /media/$USER/" >&2
    return 1
  elif [[ "${#drives[@]}" == 1 ]]; then
    echo "${drives[0]}"
  else
    # TODO(nfischer): this should really support this case...
    echo "Found too many drives: ${drives[@]}" >&2
    return 2
  fi
}

drive_name="$(find_drive)"
output_dir="/media/$USER/$drive_name/${host}-${date}/"

# Must have trailing slash
echo "Backup up into '${output_dir}'"
read -p "Press enter to continue (ctrl-c to quit)" dummyvar

# If this fails, it indicates some bad state
mkdir "${output_dir}"

backup_start="$(date +%s)"
rsync --info=progress2 -av --exclude-from="$EXCLUDE_LIST" \
  "$HOME/" \
  "${output_dir}"
backup_end="$(date +%s)"

runtime=$((backup_end-backup_start))

log_metadata() {
  echo "$@" >> "${output_dir}/BACKUP_METADATA.txt"
}
log_metadata "Backed up on $(date)"
log_metadata "Size: $(du -sh "${output_dir}")"
log_metadata "Time to backup: ${runtime} seconds"
log_metadata "Top-level files and folders: $(ls ${output_dir})"

echo ""
cat "${output_dir}/BACKUP_METADATA.txt"

echo ""
echo "Done"
