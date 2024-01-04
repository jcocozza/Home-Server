#!/bin/bash
#
# Install the passed service
#
# Environment Variables
#   BASE_USER

machine_ip="$1"
service_name="$2"

echo "########## Installing $service_name on $machine_ip ##########"

service_install_path="services/$service_name/install.sh"

echo "Running $service_install_path on $machine_ip..."
ssh -t "$BASE_USER@$machine_ip" "source exports.sh; bash -s" < "$service_install_path"