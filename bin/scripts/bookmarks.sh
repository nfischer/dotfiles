function BKMKDIR() {
  echo "$HOME/bookmarks"
}

## Create a bookmark
function mark() {
  if [ "$1" == "--help" ]; then
    cat << EOF
About: This creates a bookmark to the current directory
Usage: mark [nickname]

See also: jumpmark
EOF
    return 0
  elif [[ "$1" == "-"* ]]; then
    echo "Invalid bookmark name: '$1' (names can't start with a hyphen)" >&2
    return 1
  fi

  # Create bookmarks directory
  if [ ! -d "$(BKMKDIR)" ]; then
    mkdir "$(BKMKDIR)" || return $?
  fi

  # Special options
  if [ "$1" == "ls" ]; then
    ls "$(BKMKDIR)"
  elif [ "$1" == "rm" ]; then
    rm "$(BKMKDIR)/$1"
  elif [ "$1" == "clean" ]; then
    for k in `ls "$(BKMKDIR)/"`; do
      if [ ! -e "$(BKMKDIR)/$k" ]; then
        # symlink is broken
        echo "$k is broken"
        rm "$(BKMKDIR)/$k"
      fi
    done
  else
    local mark_name
    if [ -z "$1" ]; then
      mark_name=${PWD##*/}
    else
      mark_name=$1
    fi
    local link_name="$(BKMKDIR)/${mark_name}"
    if [ -L "${link_name}" ]; then
      if [ "`readlink "${link_name}"`" == "$PWD" ]; then
        echo "This bookmark already exists"
        return 0
      else
        echo "collision" >&2
        return 1
      fi
    else
      ln -s "$PWD" "$(BKMKDIR)/${mark_name}"
      echo "Mark created as '${mark_name}'"
      return 0
    fi
  fi
  return 0
}

## Jump to a bookmark
function jumpmark() {
  if [ "$1" == "--help" ]; then
    cat << EOF
About: This jumps to a mark created by mark
Usage: jumpmark <NAME>

See also: mark
EOF
    return 0
  elif [[ "$1" == "-"* ]]; then
    echo "Invalid bookmark name: '$1' (names can't start with a hyphen)" >&2
    return 1
  fi

  if [ -z "$1" ]; then
    echo "Specify a mark" >&2
    return 1
  fi

  local link_name="$(BKMKDIR)/$1"
  if [ -L "${link_name}" ]; then
    cd `readlink "${link_name}"`
  else
    echo "Link doesn't exist" >&2
    return 1
  fi
  return 0
}
