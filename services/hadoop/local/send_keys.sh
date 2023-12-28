#!/bin/bash
#
# Send the public key file to the passed ip addresses
#
# Environment Variables
#   HADOOP_USERNAME

machines=("$@")  ## List of ip addresses

# Define the SSH key filename for the hadoop user
keyfile="/home/$HADOOP_USERNAME/.ssh/hadoop"
su - "$HADOOP_USERNAME" -c "ssh-keygen -t rsa -f $keyfile -N \"\""

curr_ip=$(ip addr show | grep -oP '(?<=inet\s)\d+(\.\d+){3}' | grep -v '127.0.0.1')
for ipaddr in "${machines[@]}"; do
    if [[ "$ipaddr" != "$curr_ip" ]]
        ssh-copy-id -i $keyfile.pub "$HADOOP_USERNAME"@$ipaddr
    fi
done