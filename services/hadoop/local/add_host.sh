#!/bin/bash
#
# Add an ip address, hostname pair to the `/etc/hosts` file

ip_address=$1
host_name=$2

echo "${ip_address} ${host_name}" | sudo tee -a /etc/hosts > /dev/null