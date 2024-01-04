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
elif [[ "$system" == "Linux" ]]; then
    # Install ookla
    curl -s https://packagecloud.io/install/repositories/ookla/speedtest-cli/script.deb.sh | sudo bash
    sudo apt update
    sudo apt install speedtest
fi

# Install go_speedtest tool
echo "curl request: https://github.com/jcocozza/go_speedtest/releases/download/$go_speedtest_version/go_speedtest_${system}_${architecture}"
curl -LO https://github.com/jcocozza/go_speedtest/releases/download/$go_speedtest_version/go_speedtest_${system}_${architecture}

chmod +x go_speedtest_${system}_${architecture}