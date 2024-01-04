#!/bin/bash
#
# The main setup script

#repo_dir=$(cd $(dirname $0);pwd)

python3 exports.py
source exports.sh

python3 setup.py
