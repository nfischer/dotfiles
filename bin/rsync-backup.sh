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
  local -a num_drives="${#drives[@]}"
  if [[ "${num_drives}" < 1 ]]; then
    echo "Could not find any drives at /media/$USER/" >&2
    return 1
  elif [[ "${num_drives}" == 1 ]]; then
    echo "${drives[0]}"
  else
    echo "Available drives: " >&2
    for ((idx=0; idx < "${num_drives}"; idx++)); do
      echo "${idx} ${drives[${idx}]}" >&2
    done

    read -p "Please select a drive number: " drivechoice
    if ! [[ "${drivechoice}" == ?(-)+([0-9]) ]]; then
      echo "Please enter an actual number: '${drivechoice}'" >&2
      return 2
    fi
    if [[ "${drivechoice}" -ge 0 ]] && [[ "${drivechoice}" -lt "${num_drives}" ]]; then
      echo "${drives[${drivechoice}]}"
    else
      echo "Invalid choice: '${drivechoice}'" >&2
      return 2
    fi
  fi
}

drive_name="$(find_drive)"
output_dir="/media/$USER/$drive_name/${host}-${date}/"

# Must have trailing slash
echo "Backing up into '${output_dir}'"
read -p "Press enter to continue (ctrl-c to quit)" dummyvar

# If this fails, it indicates some bad state
mkdir "${output_dir}"

backup_start="$(date +%s)"
rsync --info=progress2 -av --exclude-from="$EXCLUDE_LIST" \
  "$HOME/" \
  "${output_dir}"
backup_end="$(date +%s)"

runtime=$(((backup_end-backup_start)/60))

log_metadata() {
  echo -e "$@" >> "${output_dir}/BACKUP_METADATA.txt"
}
log_metadata "Backed up on $(date)"
log_metadata "Size: $(du -sh "${output_dir}")"
log_metadata "Time to backup: ${runtime} minutes"
log_metadata "\nTop-level files and folders:\n$(ls ${output_dir})"

echo ""
cat "${output_dir}/BACKUP_METADATA.txt"

echo ""
echo "Done"
