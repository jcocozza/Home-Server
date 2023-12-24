#!/bin/bash
#
# Install the speedtest tooling

go_speedtest_version="v0.0.1-alpha"
system="$(uname -s)"
architecture="$(uname -m)"

if [[ "$system" == "Darwin" ]]; then
    # Install ookla
    brew tap teamookla/speedtest
    brew update
    brew install speedtest --force

    curl -LO https://github.com/jcocozza/go_speedtest/releases/download/$go_speedtest_version/go_speedtest_$system_$architecture
    chmod +x go_speedtest_$system_$architecture
elif [[ "$system" == "Linux" ]]; then
    # Install ookla
    curl -s https://packagecloud.io/install/repositories/ookla/speedtest-cli/script.deb.sh | sudo bash
    sudo apt-get install speedtest

    # Install go_speedtest tool
    curl -LO https://github.com/jcocozza/go_speedtest/releases/download/$go_speedtest_version/go_speedtest_$system
    chmod +x go_speedtest_$system
fi