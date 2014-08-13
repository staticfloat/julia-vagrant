#!/bin/bash
date > /etc/vagrant_box_build_time

HOME_DIR=""
if [[ $(uname -s) == "Darwin" ]]; then
    OSX_VERS=$(sw_vers -productVersion | awk -F "." '{print $2}')

    # Set computer/hostname
    COMPNAME=osx-10.${OSX_VERS}
    scutil --set ComputerName ${COMPNAME}
    scutil --set HostName ${COMPNAME}

    HOME_DIR="/Users/vagrant"
elif [[ $(uname -s) == "Linux" ]]; then
    # Find distribution and release
    DISTRIB=""
    RELEASE=""
    if [[ -f /etc/lsb-release ]]; then
        source /etc/lsb-release
        DISTRIB=$(echo $DISTRIB_ID | tr '[:upper:]' '[:lower:]')
        RELEASE=$DISTRIB_RELEASE
    elif [[ -f /etc/system-release ]]; then
        DISTRIB=linux
        RELEASE=unknown
    fi

    if [[ $(uname -m) == "x64_86" ]]; then
        ARCH=x64
    else
        ARCH=x86
    fi
    
    COMPNAME=${DISTRIB}${RELEASE}-${ARCH}
    hostname $COMPNAME
    echo $COMPNAME > /etc/hostname
    echo "127.0.0.1 $COMPNAME" >> /etc/hosts

    HOME_DIR="/home/vagrant"
fi

# Installing vagrant keys
mkdir ${HOME_DIR}/.ssh
chmod 700 ${HOME_DIR}/.ssh
curl -L 'https://raw.githubusercontent.com/mitchellh/vagrant/master/keys/vagrant.pub' > ${HOME_DIR}/.ssh/authorized_keys
chmod 600 ${HOME_DIR}/.ssh/authorized_keys
chown -R vagrant ${HOME_DIR}/.ssh

# Create vagrant group and assign vagrant user to it
if [[ $(uname -s) == "Darwin" ]]; then
    dseditgroup -o create vagrant
    dseditgroup -o edit -a vagrant vagrant
fi
