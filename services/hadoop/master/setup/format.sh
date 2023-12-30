#!/bin/bash
#
# Format the hdfs file system
# Environment Variables
#   HADOOP_LOACTION

source /etc/environment
export HADOOP_HOME=$HADOOP_LOCATION
export PATH=$PATH:$HADOOP_HOME/bin
hdfs namenode -format