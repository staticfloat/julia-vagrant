#!/bin/bash

sudo pacman -Syu

PKGS="perl linux-headers net-tools git python2 python2-pip htop tmux"

for PKG in $PKGS; do
    echo "Installing $PKG"
    sudo pacman --noconfirm -S $PKG
done