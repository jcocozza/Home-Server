#!/bin/bash
#
# The main setup script

repo_dir=$(cd $(dirname $0);pwd)

python3 exports.py
bash exports.sh
mv exports.sh ~

cd ~
mkdir $HOME_SERVER_DIR
mv exports.sh $HOME_SERVER_DIR

cd $HOME_SERVER_DIR
