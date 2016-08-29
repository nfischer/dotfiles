#!/bin/bash

## Run this script for installing this on a new unix system.

cd "$(dirname "$0")" # make sure we're in the correct directory

# Apt-get dependencies
deps=( nvim git git-extras tmux xbindkeys zsh z )

echo "This script requires root priviledge"
sudo apt-get update &&
sudo apt-get upgrade -y &&
(
  set -e
  for d in "${deps[@]}"; do
    echo "apt-get installl $d"
    sudo apt-get install -y "$d" >/dev/null
  done
) || echo "failed on apt-get command" >&2

# Install node version manager
wget -qO- https://raw.githubusercontent.com/creationix/nvm/v0.31.1/install.sh | bash || echo "Couldn't install nvm" >&2

# Install oh-my-zsh
(which curl &>/dev/null &&
sh -c "$(curl -fsSL https://raw.githubusercontent.com/robbyrussell/oh-my-zsh/master/tools/install.sh)" ||
echo "Curl is missing" >&2 ) &&


mkdir -p "$HOME/packages" &&
( cd "$HOME/packages" &&
git clone https://github.com/somnol/oh-my-zsh-theme-modified-amuse.git &&
test -n "$ZSH_CUSTOM" &&
cp -rv oh-my-zsh-theme-modified-amuse/lib/ oh-my-zsh-theme-modified-amuse/themes/ "$ZSH_CUSTOM"
)

which npm &>/dev/null || echo 'Please install node and npm' >&2

echo ''
echo 'done'
