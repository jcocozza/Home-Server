#!/bin/bash
#
# Start wg-monitor
#
# Environment Variables
#   WIREGUARD_PATH

system="$(uname -s)"
architecture="$(uname -m)"

sudo ./wg-monitor_${system}_${architecture} $WIREGUARD_PATH