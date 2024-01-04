#!/bin/bash
#
# Check if hadoop is up and running
#
# Environment Variables
#   HADOOP_USERNAME
#   HADOOP_MASTER_IP

ssh "$HADOOP_USERNAME@$HADOOP_MASTER_IP" "source exports.sh; hdfs dfsadmin -report; yarn rmadmin -getServiceState rm"

# TODO finish this
