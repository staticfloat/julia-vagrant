#!/bin/bash

# Get base system up and running
git clone https://github.com/staticfloat/julia-buildbot.git ~/buildbot
cd ~/buildbot

# Initialize virtualenv
sudo pip install virtualenv twisted
virtualenv --no-site-packages sandbox
chmod +x sandbox/bin/activate
source sandbox/bin/activate

# Install buildbot, and run it 
pip install buildbot
buildbot create-master master

# Setup buildbot to run at startup every time
crontab -l > /tmp/crontab
tee -a /tmp/crontab >/dev/null <<EOF
@reboot cd $(echo ~)/buildbot && sandbox/bin/buildbot start master &
@reboot cd $(echo ~)/buildbot && ./launch_github.sh &
EOF
crontab /tmp/crontab


# Set our hostname to "buildbot"
echo buildbot | sudo tee /etc/hostname >/dev/null
echo 127.0.0.1 buildbot | sudo tee -a /etc/hosts >/dev/null