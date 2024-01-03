#!/bin/bash

# This script will set up the peer configuration on the machine it is being run on

# Environment variables:
#   WIREGUARD_PATH
#   WG_NAME
#   WG_SERVER_PUBLIC_KEY
#   WG_ALLOWED_IPS
#   WG_ENDPOINT

ASSIGNED_ADDRESS=$1
server_public_key=$2
PRIVATE_KEY_PATH="$WIREGUARD_PATH/private.key"
PUBLIC_KEY_PATH="$WIREGUARD_PATH/public.key"

# Generate private key for host
wg genkey | sudo tee $PRIVATE_KEY_PATH
sudo chmod go= $PRIVATE_KEY_PATH

# Generate public key for host
sudo cat $PRIVATE_KEY_PATH | wg pubkey | sudo tee $PUBLIC_KEY_PATH

# create the config file
CONF_PATH="$WIREGUARD_PATH/$WG_NAME.conf"

interface="[Interface]
PrivateKey = $(sudo cat $PRIVATE_KEY_PATH)
Address = $ASSIGNED_ADDRESS/32"

#echo "$interface" > $CONF_PATH
echo "$interface" | sudo tee -a "$CONF_PATH" > /dev/null


peer="[Peer]
PublicKey = $server_public_key
AllowedIPs = $WG_ALLOWED_IPS
EndPoint = $WG_ENDPOINT"

#echo "$peer" > $CONF_PATH
echo "$peer" | sudo tee -a "$CONF_PATH" > /dev/null
