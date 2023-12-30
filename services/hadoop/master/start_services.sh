#!/bin/bash
#
# Start hadoop services


export HADOOP_HOME=$HADOOP_LOCATION
export PATH=$PATH:$HADOOP_HOME/bin

$HADOOP_HOME/sbin/start-dfs.sh
$HADOOP_HOME/bin/yarn --daemon start resourcemanager
