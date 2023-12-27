#!/bin/bash
#
# This script will distribute the hadoop configuration to the passed hostnames
#
# Environment Variables
#   HADOOP_LOCATION

# Append slave nodes to a workers file
for node in "$@"; do
    scp $HADOOP_LOCATION/etc/hadoop/* $node:$HADOOP_LOCATION/etc/hadoop/
done