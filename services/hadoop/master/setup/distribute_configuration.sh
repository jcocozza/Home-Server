#!/bin/bash
#
# This script will distribute the hadoop configuration to the passed ip address
#
# Environment Variables
#   HADOOP_LOCATION

node="$1"
scp -r -i ~/.ssh/hadoop $HADOOP_LOCATION/etc/hadoop/* $node:$HADOOP_LOCATION/etc/hadoop/
