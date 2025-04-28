#!/bin/bash
set -e

apt-get update -y && apt-get -y install --no-install-recommends tmux pre-commit wget
#wget "https://github.com/gitleaks/gitleaks/releases/download/v8.24.3/gitleaks_8.24.3_linux_x64.tar.gz" && tar xf gitleaks_8.24.3_linux_x64.tar.gz && mv gitleaks /bin/gitleaks && rm gitleaks_8.24.3_linux_x64.tar.gz
#apt-get update -y && apt-get -y install --no-install-recommends tmux universal-ctags nix
#usermod -aG nix-users vscode
#echo 'export PATH+=:~/.nix-profile/bin' >> /home/vscode/.bashrc
#nix-channel --add https://nixos.org/channels/nixpkgs-unstable
#nix-channel --update
#nix-daemon &
#sudo -u vscode nix-env -iA nixpkgs.neovim

rm -rf /var/lib/apt/lists/*
