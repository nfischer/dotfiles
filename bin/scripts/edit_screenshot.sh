#!/bin/bash
which gimp &>/dev/null && has_gimp=true || has_gimp=false

# Edits the last screenshot I took, so I don't have to do all that damn
# searching myself. Only works on systems that have gimp installed. Probably
# only works on Ubuntu (since relies on naming convention of screenshots)
function edit_screenshot()
{
  "${has_gimp}" || { echo "This requires gimp" && return 1; }
  local last_pic=$(ls ~/Pictures/Screenshot* | tail -n 1)
  echo "${last_pic}"
  gimp "${last_pic}"
}
