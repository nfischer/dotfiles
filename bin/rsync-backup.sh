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

convert_number() {
  local num="$1"

  local num_int="${num:0:${#num}-1}"
  local num_units="${num: -1}"
  # Assume num has units on the end. Also, keep this simple by just multiplying
  # by 1000 (instead of 1024, which would be more correct).
  if [[ "${num_units}" == "G" ]]; then
    num_int=$(($num_int*1000))
    local num_units="M"
  fi
  if [[ "${num_units}" == "M" ]]; then
    num_int=$(($num_int*1000))
    local num_units="K"
  fi
  if [[ "${num_units}" == "K" ]]; then
    num_int=$(($num_int*1000))
    local num_units=""
  fi
  echo "${num_int}"
}

warn_if_insufficent_space() {
  local last_backup_dir="$1"
  local free_space="$2"

  local last_backup_dir_size="$(convert_number "${last_backup_dir}")"
  local free_space_size="$(convert_number "${free_space}")"

  local margin=2000000000 # 2G
  if [[ "$(($last_backup_dir_size+$margin))" > "${free_space_size}" ]]; then
    echo "WARN: there may not be enough space to backup on the external drive"
  fi
}

drive_name="$(find_drive)"
drive_path="/media/$USER/${drive_name}"
output_dir="${drive_path}/${host}-${date}"
free_space="$(df -h "${drive_path}" | tail -1 | awk '{print $4}')"

echo "Backing up into '${output_dir}/'"
echo "Free space on external drive: ${free_space}"

last_backup_dir="$(ls -d "${drive_path}/${host}-"* 2>/dev/null | tail -n 1)"
if [[ -z "${last_backup_dir}" ]]; then
  echo "Cannot find a previous backup for '${host}' so cannot estimate backup size." >&2
else
  last_backup_size="$(sed -En 's/^Size: ([0-9]+[KMG]?)\t.*$/\1/p' "${last_backup_dir}/BACKUP_METADATA.txt")"
  echo "Last backup (${last_backup_dir}) was ${last_backup_size}"
  warn_if_insufficent_space "${last_backup_size}" "${free_space}"
fi

read -p "Press enter to continue (ctrl-c to quit)" dummyvar

# If this fails, it indicates some bad state
mkdir "${output_dir}/"

backup_start="$(date +%s)"
rsync --info=progress2 -av --exclude-from="$EXCLUDE_LIST" \
  "$HOME/" \
  "${output_dir}/"
backup_end="$(date +%s)"

runtime=$(((backup_end-backup_start)/60))

log_metadata() {
  echo -e "$@" >> "${output_dir}/BACKUP_METADATA.txt"
}
log_metadata "Backed up on: $(date)"
log_metadata "Size: $(du -sh "${output_dir}/")"
log_metadata "Time to backup: ${runtime} minutes"
log_metadata "\n======================================"
log_metadata "\nTop-level files and folders:\n\n$(ls ${output_dir}/)"

echo ""
cat "${output_dir}/BACKUP_METADATA.txt"

echo ""
echo "Done"
