#!/bin/bash

echo "cleaning up guest additions"
# This is for VirtualBox, but I guess we'll leave them in for good measure.  :P
rm -rf VBoxGuestAdditions_*.iso VBoxGuestAdditions_*.iso.?
rm -f linux.iso

if [[ "$(uname -s)" == "Linux" ]]; then
    if [[ ! -z $(which apt-get 2>/dev/null) ]]; then
        apt-get -y autoremove
        apt-get -y clean
    fi

    if [[ ! -z $(which yum 2>/dev/null) ]]; then
        yum clean all
    fi

    echo "cleaning up dhcp leases"
    rm /var/lib/dhcp/*

    echo "cleaning up udev rules"
    rm /etc/udev/rules.d/70-persistent-net.rules
    mkdir /etc/udev/rules.d/70-persistent-net.rules
    rm -rf /dev/.udev/
    rm /lib/udev/rules.d/75-persistent-net-generator.rules
fi


echo "zeroing out rest of disk...."
if [[ "$(uname -s)" == "Linux" ]]; then    
    dd if=/dev/zero of=/EMPTY bs=1M
    sync
    rm -f /EMPTY
elif [[ "$(uname -s)" == "Darwin" ]]; then
    diskutil secureErase freespace 0 /
fi
