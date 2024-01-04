#!/bin/bash
#
# stop hadoop services
#
# Environment Variables
#   HADOOP_USERNAME
#   HADOOP_MASTER_IP

ssh "$HADOOP_USERNAME@$HADOOP_MASTER_IP" "source exports.sh; bash -s" < "services/hadoop/master/stop_service.sh"