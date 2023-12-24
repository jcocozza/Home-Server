#!/bin/bash
#
# This script will set up the server configuration on the machine it is being run on
#
# Environment variables:
#   WIREGUARD_PATH
#   WG_NAME
#   WG_LISTENPORT

ASSIGNED_ADDRESS=$1
PRIVATE_KEY_PATH="$WIREGUARD_PATH/private.key"
PUBLIC_KEY_PATH="$WIREGUARD_PATH/public.key"

# Generate private key for host
wg genkey | sudo tee $PRIVATE_KEY_PATH
sudo chmod go= $PRIVATE_KEY_PATH

# Generate public key for host
sudo cat $PRIVATE_KEY_PATH | wg pubkey | sudo tee $PUBLIC_KEY_PATH

# create the config file
CONF_PATH="$WIREGUARD_PATH/$WG_NAME.conf"

echo "[INTERFACE]" > $CONF_PATH
echo "PrivateKey = ${sudo cat $PRIVATE_KEY_PATH}" > $CONF_PATH
echo "Address = $ASSIGNED_ADDRESS" > $CONF_PATH
echo "ListenPort = $WG_LISTENPORT" > $CONF_PATH

