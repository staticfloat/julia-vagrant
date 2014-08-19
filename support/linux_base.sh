#!/bin/bash

# Enable passwordless sudo
if [[ -z $(cat /etc/sudoers | grep vagrant | grep NOPASSWD) ]]; then
    echo "vagrant ALL=(ALL) NOPASSWD: ALL" >> /etc/sudoers
fi

# Disable requiring a TTY in files
sed -i -e 's/\s*Defaults\s*requiretty$/#Defaults    requiretty/' /etc/sudoers
sed -i -e 's/\s*Defaults\s*!visiblepw$/#Defaults    !visiblepw/' /etc/sudoers

echo "UseDNS no" >> /etc/ssh/sshd_config

# I really hate the fact that /etc/rc.local has "exit 0" at the end;
# I'd like to be able to append commands, thank you very much!
tee /etc/rc.local >/dev/null << EOF
#!/bin/bash
# Put commands in here to be run at startup
EOF