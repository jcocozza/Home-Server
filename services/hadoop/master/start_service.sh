#!/bin/bash
#
# Start hadoop services
#
# Environment Variables
#   HADOOP_LOCATION

# export HADOOP_HOME=/opt/hadoop;export PATH=$PATH:$HADOOP_HOME/bin
export HADOOP_HOME=$HADOOP_LOCATION
export PATH=$PATH:$HADOOP_HOME/bin

$HADOOP_HOME/sbin/start-dfs.sh
$HADOOP_HOME/sbin/start-yarn.sh