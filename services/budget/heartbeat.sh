#!/bin/bash
#
# Check if the actual server is running

actual_port=5006

# check for connection refused on the machine running the actual server
stat=$(telnet localhost "$actual_port" | grep "Connection refused")

if [[ "$stat" == "" ]]; then
    exit 1 # exit true
fi

exit 0 # exit false