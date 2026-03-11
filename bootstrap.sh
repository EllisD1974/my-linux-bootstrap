#!/usr/bin/env bash
set -e

echo "Updating system..."
sudo apt update
sudo apt upgrade -y

echo "Installing packages..."
bash install/packages.sh

echo "Installing docker..."
bash install/docker.sh

echo "Setting up dotfiles..."
bash install/dotfiles.sh

echo "Installing devtools-ui..."
bash install/devtools-ui.sh

echo "Creating directories..."
mkdir -p ~/developer/repos
mkdir -p ~/scripts
mkdir -p ~/data
mkdir -p ~/tmp

echo "Bootstrap complete."
