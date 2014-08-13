#!/bin/bash
# This file for Linux only, obviously

sudo apt-get update
sudo apt-get -y upgrade
sudo apt-get -y install software-properties-common

# These are needed for the rest of the provisioning process
PKGS="linux-headers-$(uname -r) curl git build-essential g++ gcc cloud-init"

for PKG in $PKGS; do
	echo "Installing $PKG"
	sudo apt-get -y install $PKG
done

sed -i -e '/Defaults\s\+env_reset/a Defaults\texempt_group=sudo' /etc/sudoers
sed -i -e 's/%sudo  ALL=(ALL:ALL) ALL/%sudo  ALL=NOPASSWD:ALL/g' /etc/sudoers

echo "UseDNS no" >> /etc/ssh/sshd_config
