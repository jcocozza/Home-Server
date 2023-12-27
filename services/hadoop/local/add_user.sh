#!/bin/bash
#
# Creates the "hadoop" user for a machine
#
# Environment Variables
#   HADOOP_USERNAME
#   HADOOP_USER_PASSWORD
#   HADOOP_LOCATION

echo $HADOOP_USERNAME



sudo useradd -m -s /bin/bash $HADOOP_USERNAME
echo "$HADOOP_USERNAME:$HADOOP_USER_PASSWORD" | sudo chpasswd

sudo usermod -aG $HADOOP_USERNAME $HADOOP_USERNAME
sudo adduser $HADOOP_USERNAME sudo