#!/bin/bash

# Clear out the cache in case something went horribly wrong
sudo rm -fR /var/lib/apt/lists/*
sudo apt-get update
sudo apt-get -y upgrade
sudo apt-get -y install software-properties-common python-software-properties

# These are needed for the rest of the provisioning process
PKGS="linux-headers-$(uname -r) curl git build-essential g++ gcc python-pip python-dev python bzr devscripts"

# These are needed because they're awesome
PKGS="$PKGS htop tmux"

for PKG in $PKGS; do
    echo "Installing $PKG"
    sudo apt-get -y install $PKG
done

echo "Done installing packages"
