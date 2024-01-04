#!/bin/bash
#
# This script will install a bedrock server

mkdir bedrock-mc
cd bedrock-mc

sudo apt update
sudo apt install unzip

curl -LO https://minecraft.azureedge.net/bin-linux/bedrock-server-1.20.51.01.zip
unzip bedrock-server-1.20.51.01.zip