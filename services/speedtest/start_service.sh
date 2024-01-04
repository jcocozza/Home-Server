#!/bin/bash
#
# Start the speedtest services

system="$(uname -s)"
architecture="$(uname -m)"

application_prefix="go_speedtest"

app_binary="${application_prefix}_${system}_${architecture}"
./$app_binary

# add to crontab
echo "0 */1 * * * ./$app_binary" | crontab -
