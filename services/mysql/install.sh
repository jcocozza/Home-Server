#!/bin/bash
#
# This script installs mysql non-interactively

# Install MySQL Server
sudo apt-get update
sudo DEBIAN_FRONTEND=noninteractive apt-get install -y mysql-server

# Set MySQL root password non-interactively
# MYSQL_ROOT_PASSWORD is an environment variable
sudo debconf-set-selections <<< "mysql-server mysql-server/root_password password $MYSQL_ROOT_PASSWORD"
sudo debconf-set-selections <<< "mysql-server mysql-server/root_password_again password $MYSQL_ROOT_PASSWORD"
