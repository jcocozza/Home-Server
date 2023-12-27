#!/bin/bash
#
# Install hadoop
#
# Environment Variables
#   HADOOP_VERSION
#   HADOOP_LOCATION
#   HADOOP_USERNAME

sudo apt install openjdk-11-jdk
java_folder="java-11-openjdk-amd64"

wget https://dlcdn.apache.org/hadoop/common/$HADOOP_VERSION/$HADOOP_VERSION.tar.gz
tar xzf $HADOOP_VERSION.tar.gz

mv $HADOOP_VERSION hadoop

echo "export JAVA_HOME=/usr/lib/jvm/$java_folder/" >> ~/hadoop/etc/hadoop/hadoop-env.sh

mv hadoop "$HADOOP_LOCATION"

sudo chown $HADOOP_USERNAME:root -R "$HADOOP_LOCATION"
sudo chmod g+rwx -R "$HADOOP_LOCATION"