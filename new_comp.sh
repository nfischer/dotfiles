#!/bin/bash

cd "$(dirname "$0")" # make sure we're in the correct directory

DIR="install-this-stuff"
mkdir "$DIR"
cd "$DIR"

wget -qO- https://raw.githubusercontent.com/creationix/nvm/v0.31.1/install.sh > install-nvm.sh

# Install zplug
curl -sL zplug.sh/installer  > install-zplug.zsh

TMUX_PLUGIN_DIR="$HOME/.tmux/plugins/tpm"
cat > install-tmux-plugin-manager.sh <<END
#!/bin/bash

# Before you run this, double-check if tmux plugin manager is already cloned
# there! You can use vim's 'gf' command to jump to the folder if it exists.
git clone https://github.com/tmux-plugins/tpm "${TMUX_PLUGIN_DIR}"
END

mkdir -p "$HOME/packages"

cat<<END
This script no longer installs things for you, since that usually requires
running untrusted code. Instead, this will download the code for you to review
and then execute.

Look inside the "install-this-stuff" folder.

Consider the following apt packages:
 - git git-extras tmux zsh python3-pip python-pip
 - nodejs npm (or, install them yourself)
 - nvim (or, build it yourself)
 - nmap
 - curl
 - gawk (hidden dependency of zplug)
 - arc-theme gnome-tweak-tool
 - xclip
 - abcde

Consider the following pip packages:
 - pip3 install --user pynvim

Consider the following npm packages:
 - npm install -g diff-so-fancy
 - npm install -g clipbaord-cli

Install npm packages in ~/bin/
 - cd ~/bin && npm install

END
