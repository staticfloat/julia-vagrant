#!/bin/bash
# This file for Linux only, obviously

sudo apt-get update
sudo apt-get -y upgrade
sudo apt-get -y install software-properties-common

# These are needed for the rest of the provisioning process
PKGS="linux-headers-$(uname -r) curl git build-essential g++ gcc"

# These are needed because they're awesome
PKGS="$PKGS htop"

for PKG in $PKGS; do
    echo "Installing $PKG"
    sudo apt-get -y install $PKG
done