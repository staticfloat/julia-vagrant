#!/bin/bash

if [[ $(uname -s) == "Darwin" ]]; then
    TOOLS_PATH="/Users/vagrant/darwin.iso"
    if [ ! -e "$TOOLS_PATH" ]; then
        echo "Couldn't locate uploaded tools iso at $TOOLS_PATH!"
        exit 1
    fi

    TMPMOUNT=`/usr/bin/mktemp -d /tmp/vmware-tools.XXXX`
    hdiutil attach "$TOOLS_PATH" -mountpoint "$TMPMOUNT"

    INSTALLER_PKG="$TMPMOUNT/Install VMware Tools.app/Contents/Resources/VMware Tools.pkg"
    if [ ! -e "$INSTALLER_PKG" ]; then
        echo "Couldn't locate VMware installer pkg at $INSTALLER_PKG!"
        exit 1
    fi

    echo "Installing VMware tools.."
    installer -pkg "$TMPMOUNT/Install VMware Tools.app/Contents/Resources/VMware Tools.pkg" -target /

    # This usually fails
    hdiutil detach "$TMPMOUNT"
    rm -rf "$TMPMOUNT"
    rm -f "$TOOLS_PATH"

    # Point Linux shared folder root to that used by OS X guests,
    # useful for the Hashicorp vmware_fusion Vagrant provider plugin
    mkdir /mnt
    ln -sf /Volumes/VMware\ Shared\ Folders /mnt/hgfs
elif [[ $(uname -s) == "Linux" ]]; then
    TOOLS_PATH="/home/vagrant/linux.iso"
    if [ ! -e "$TOOLS_PATH" ]; then
        echo "Couldn't locate uploaded tools iso at $TOOLS_PATH!"
        exit 1
    fi

    TMPMOUNT=`mktemp -d /tmp/vmware-tools.XXXX`
    mount $TOOLS_PATH $TMPMOUNT

    ls -la $TMPMOUNT
    tar zxvf $TMPMOUNT/VMwareTools-*.tar.gz -C /tmp/
    cd /tmp/vmware-tools-distrib
    echo "PRE VMWARE-INSTALL"
    ./vmware-install.pl -d
    echo "POST VMWARE-INSTALL: $?"
    #apt-get -y install open-vm-tools
    #echo -n ".host:/ /mnt/hgfs vmhgfs rw,ttl=1,uid=my_uid,gid=my_gid,nobootwait 0 0" >> /etc/fstab
fi
echo "We done here"