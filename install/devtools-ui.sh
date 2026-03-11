#!/usr/bin/env bash
set -e

echo "Installing GUI development tools..."

sudo apt update

# Install general GUI tools
sudo apt install -y \
    filezilla \
    dbeaver-ce \

echo "Installing JetBrains Toolbox (for PyCharm)..."

# Download JetBrains Toolbox
TMP_DIR=$(mktemp -d)

cd $TMP_DIR

curl -L https://download.jetbrains.com/toolbox/jetbrains-toolbox-latest.tar.gz -o toolbox.tar.gz

tar -xzf toolbox.tar.gz

TOOLBOX_DIR=$(find . -maxdepth 1 -type d -name "jetbrains-toolbox-*")

$TOOLBOX_DIR/jetbrains-toolbox &

echo ""
echo "JetBrains Toolbox launched."
echo "Use it to install PyCharm Professional."
echo ""
echo "Done."
