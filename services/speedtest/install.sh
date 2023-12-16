#!/bin/bash

if [[ $(uname -s) == "Darwin" ]]; then
    brew tap teamookla/speedtest
    brew update
    brew install speedtest --force
elif [[ $(uname -s) == "Linux" ]]; then
    # Install speedtest
    curl -s https://packagecloud.io/install/repositories/ookla/speedtest-cli/script.deb.sh | sudo bash
    sudo apt-get install speedtest
fi
