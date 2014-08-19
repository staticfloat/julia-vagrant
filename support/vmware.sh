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

    mkdir /tmp/vmware-build
    cd /tmp/vmware-build
    curl -L https://github.com/rasa/vmware-tools-patches/archive/master.tar.gz | tar zxv --strip=1
    cp $TMPMOUNT/VMwareTools-*.tar.gz .

    # Make fake /etc/init.d/rcX.d folders
    if [[ ! -d /etc/init.d/rc0.d ]]; then
        for x in {0..6}; do
            mkdir -p /etc/init.d/rc$x.d
        done
    fi

    # Remove all folders except for vmhgfs!
    rm -rf patches/{pvscsi,vmblock,vmci,vmmemctl,vmsync,vmxnet,vmxnet3,vsock}
    # remove all remaining patches except the ones we want!
    rm -rf patches/vmhgfs/vmhgfs-uid*
    rm -rf patches/vmhgfs/vmware9*

    ./untar-and-patch-and-compile.sh
fi