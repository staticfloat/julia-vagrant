#!/bin/bash

# Save script out to ~/resizedisk.sh
tee ~/resizedisk.sh >/dev/null << XYZ
#!/bin/bash

date
# Start by expanding partition
sfdisk --no-reread -N1 /dev/vda << EOF
,+,
y
EOF
# Re-read partition table
partprobe -s
# Resize filesystem
resize2fs /dev/vda1
XYZ

# Make it executable
chmod +x ~/resizedisk.sh

# Shove it into /etc/rc.local
sudo tee -a /etc/rc.local >/dev/null << EOF
$(echo ~)/resizedisk.sh > ~/resizedisk.log
EOF