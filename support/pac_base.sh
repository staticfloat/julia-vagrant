#!/bin/bash

sudo pacman -Syu

PKGS="perl linux-headers net-tools git python2 python2-pip htop tmux cronie parted"

for PKG in $PKGS; do
    echo "Installing $PKG"
    sudo pacman --noconfirm -S $PKG
done

# Let's rename pip2 and python2 to pip and python2
cd /usr/bin
sudo ln -s pip2 pip
sudo ln -s python2 python