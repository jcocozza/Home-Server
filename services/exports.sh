#!/bin/bash
#
# Variables that are exported to be used by other scripts 

# MYSQL
export MYSQL_ROOT_PASSWORD="mysql_root_password"

# WIREGUARD
export WG_SERVER_PUBLIC_KEY="wg_server_public_key"
export WG_ENDPOINT="endpoint"
export WG_ALLOWED_IPS="0.0.0.0/0,::/0"
export WG_NAME="wg0"
export WG_LISTENPORT="51820"
