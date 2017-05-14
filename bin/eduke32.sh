#!/bin/bash

GAME_FOLDER="$HOME/.eduke32_src/eduke32"
DUKE="eduke32"           # Game binary
HRP="duke3d_hrp.zip"     # High Res Pack

result=0
cd "$GAME_FOLDER" 2>/dev/null || exit 1

if [ "$1" == "-n" -o "$1" == "--normal" ]; then
  "./$DUKE"
  result=$?
else
  "./$DUKE" -grp "$HRP"
  result=$?
fi

exit $result