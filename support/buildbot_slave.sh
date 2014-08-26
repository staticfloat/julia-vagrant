#!/bin/bash

if [[ $(uname -s) == "Darwin" ]]; then
    export PATH="$PATH:/usr/local/bin:/usr/local/sbin"
fi

cd
mkdir buildbot
sudo pip install virtualenv

# This just so that we can build the docs!
sudo pip install sphinx_rtd_theme

cd buildbot
virtualenv --no-site-packages sandbox
chmod +x sandbox/bin/activate
source sandbox/bin/activate
pip install buildbot-slave

# We don't care that we're leaking the "secret" here
buildslave create-slave --keepalive=100 slave buildbot.e.ip.saba.us:9989 $(hostname) julialang42

# let's personalize this buildslave a bit
echo "Elliot Saba <staticfloat@gmail.com>" > slave/info/admin
echo "Julia $HOSTNAME buildbot" > slave/info/host

# Setup buildbot to run at startup every time
crontab -l >/tmp/crontab 2>/dev/null
tee -a /tmp/crontab >/dev/null <<EOF
@reboot cd $(echo ~)/buildbot; sandbox/bin/buildslave start slave &
EOF
crontab /tmp/crontab