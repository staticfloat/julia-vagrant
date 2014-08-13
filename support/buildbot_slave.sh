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

# Setup buildbot to run at startup every time
echo "@reboot cd $(echo ~)/buildbot; sandbox/bin/buildslave start slave" | crontab -u vagrant -