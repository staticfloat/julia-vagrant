#!/bin/bash
sed -i -e '/Defaults\s\+env_reset/a Defaults\texempt_group=sudo' /etc/sudoers
sed -i -e 's/%sudo  ALL=(ALL:ALL) ALL/%sudo  ALL=NOPASSWD:ALL/g' /etc/sudoers

echo "UseDNS no" >> /etc/ssh/sshd_config

# I really hate the fact that /etc/rc.local has "exit 0" at the end;
# I'd like to be able to append commands, thank you very much!
sudo tee /etc/rc.local << EOF
#!/bin/bash
# Put commands in here to be run at startup
EOF