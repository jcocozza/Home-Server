#!/bin/bash
#
# Remove the samba install

sudo apt -y remove --purge samba samba-common cifs-utils smbclient
sudo rm -rf /var/cache/samba /etc/samba /run/samba /var/lib/samba /var/log/samba