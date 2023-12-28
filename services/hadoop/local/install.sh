#!/bin/bash
#
# Install hadoop
#
# Environment Variables
#   HADOOP_VERSION
#   HADOOP_LOCATION
#   HADOOP_USERNAME

java_folder="java-11-openjdk-amd64"

wget https://dlcdn.apache.org/hadoop/common/$HADOOP_VERSION/$HADOOP_VERSION.tar.gz
tar xzf $HADOOP_VERSION.tar.gz

mv $HADOOP_VERSION hadoop

echo "export JAVA_HOME=/usr/lib/jvm/$java_folder/" >> ~/hadoop/etc/hadoop/hadoop-env.sh