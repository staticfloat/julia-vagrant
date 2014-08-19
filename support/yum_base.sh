#!/bin/bash

sudo yum update -y

PKGS="net-tools nano kernel-devel htop tmux"

for PKG in $PKGS; do
    echo "Installing $PKG"
    sudo yum install -y $PKG
done

sudo easy_install pip