#!/bin/bash
#
# Start the speedtest services

system="$(uname -s)"
architecture="$(uname -m)"

application_prefix="go_speedtest_"

if [[ "$system" == "Darwin" ]]; then
    app_binary="$application_prefix_$system_$architecture"
    bash $app_binary
elif [[ "$system" == "Linux" ]]; then
    app_binary="$application_prefix_$system"
    bash $app_binary
fi

# add to crontab
echo "0 */1 * * * $app_binary" | crontab -
