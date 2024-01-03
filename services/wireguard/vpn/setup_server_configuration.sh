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
echo "Writing private key to $PRIVATE_KEY_PATH"
wg genkey | sudo tee $PRIVATE_KEY_PATH
sudo chmod go= $PRIVATE_KEY_PATH

# Generate public key for host
echo "Writing public key to $PUBLIC_KEY_PATH"
sudo cat $PRIVATE_KEY_PATH | wg pubkey | sudo tee $PUBLIC_KEY_PATH

# create the config file
echo "creating $WG_NAME.conf in $WIREGUARD_PATH"
CONF_PATH="$WIREGUARD_PATH/$WG_NAME.conf"


interface="[Interface]
    PrivateKey = $(sudo cat "$PRIVATE_KEY_PATH")
    Address = $ASSIGNED_ADDRESS/24
    ListenPort = $WG_LISTENPORT"

#echo "$interface" > $CONF_PATH
echo "$interface" | sudo tee -a "$CONF_PATH" > /dev/null
