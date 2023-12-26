#!/bin/bash
#
# Install a samba file server

samba_conf="/etc/samba/smb.conf"
fileserver_dir="/home/sharing"

sudo apt install -y samba

sudo mkdir -p "$fileserver_dir"
sudo chown -R nobody.nogroup "$fileserver_dir"
sudo chmod -R 777 "$fileserver_dir"

sudo cp "$samba_conf" "$samba_conf.backup"

share_content="[sharing]
    browseable = yes
    path = $fileserver_dir
    guest ok = yes
    read only = no
    create mask = 777"

echo "$share_content" | sudo tee -a "$samba_conf" > /dev/null

sudo systemctl restart smbd
sudo systemctl restart nmbd