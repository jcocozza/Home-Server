#!/bin/bash
#
# Check if the samba server is running

stat=$(systemctl status smbd | grep running)

if [[ "$stat" == "" ]]; then
    exit 0 # exit false
fi

exit 1 # exit true