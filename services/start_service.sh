#!/bin/bash
#
# start the passed service
#
# Environment Variables
#   BASE_USER

machine_ip="$1"
service_name="$2"

echo "########## Starting $service_name on $machine_ip ##########"


service_start_path="services/$service_name/start_service.sh"

echo "Running $service_start_path on $machine_ip..."
ssh -t "$BASE_USER@$machine_ip" "source exports.sh; bash -s" < "$service_start_path"