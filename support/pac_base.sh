#!/bin/bash

sudo pacman -Syu

PKGS="perl linux-headers net-tools"

for PKG in $PKGS; do
    echo "Installing $PKG"
    sudo pacman --noconfirm -S $PKG
done