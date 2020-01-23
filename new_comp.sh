#!/bin/bash

## Run this script for installing this on a new unix system.

cd "$(dirname "$0")" # make sure we're in the correct directory

# Apt-get dependencies
aptitude_packages=( nvim git git-extras tmux xbindkeys zsh z )

if [ -z "$CI" ]; then
  echo "This script requires root priviledge"
  sudo apt-get update &&
  sudo apt-get upgrade -y &&
  (
    set -e
    for dep in "${aptitude_packages[@]}"; do
      echo "apt-get installl ${dep}"
      sudo apt-get install -y "${dep}" >/dev/null
    done
  ) || echo "failed on apt-get command" >&2
fi

# Install node version manager
wget -qO- https://raw.githubusercontent.com/creationix/nvm/v0.31.1/install.sh | bash ||
  echo "nvm installation failed" >&2

# Install zplug
curl -sL zplug.sh/installer | zsh || echo 'zplug installation failed' >&2

# Install tmux plugin manager
TPM_DIR="$HOME/.tmux/plugins/tpm"
if [ -d "${TPM_DIR}" ]; then
  echo "TPM already installed at ${TPM_DIR}, skipping..."
else
  git clone https://github.com/tmux-plugins/tpm "${TPM_DIR}" ||
    echo 'tpm installation failed' >&2
fi

mkdir -p "$HOME/packages"

which npm &>/dev/null || echo 'Please install node and npm' >&2

echo ''
echo 'done'
