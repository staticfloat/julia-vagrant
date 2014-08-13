#!/bin/bash

sudo apt-get update
# These are needed for buildbot
PKGS="python-pip python-dev python"

for PKG in $PKGS; do
    echo "Installing $PKG"
    sudo apt-get -y install $PKG
done