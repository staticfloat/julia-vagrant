#!/bin/bash

# Get base system up and running
git clone https://github.com/staticfloat/julia-buildbot.git ~/buildbot
cd ~/buildbot

# Initialize virtualenv
sudo pip install virtualenv
virtualenv --no-site-packages sandbox
chmod +x sandbox/bin/activate
source sandbox/bin/activate

# Install buildbot, and run it 
pip install buildbot
buildbot create-master master

# Setup buildbot to run at startup every time
echo "@reboot cd $(echo ~)/buildbot; sandbox/bin/buildbot start master" | crontab -u vagrant -

# Set our hostname appropriately
sudo hostname buildbot