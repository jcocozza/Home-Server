#!/bin/bash
#
# Install wg-monitor

wg_monitor_version="v0.0.1"
system="$(uname -s)"
architecture="$(uname -m)"

curl -LO https://github.com/jcocozza/wg-monitor/releases/download/$wg_monitor_version/wg-monitor_${system}_${architecture}
chmod +x wg-monitor_${system}_${architecture}