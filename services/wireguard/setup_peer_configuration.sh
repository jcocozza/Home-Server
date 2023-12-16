#!/bin/bash

# This script will set up the peer configuration on the machine it is being run on

# Environment variables:
#   WG_NAME
#   WG_SERVER_PUBLIC_KEY
#   WG_ALLOWED_IPS
#   WG_ENDPOINT

ASSIGNED_ADDRESS=$1
PRIVATE_KEY_PATH="/etc/wireguard/private.key"
PUBLIC_KEY_PATH="/etc/wireguard/public.key"

# Generate private key for host
wg genkey | sudo tee $PRIVATE_KEY_PATH
sudo chmod go= $PRIVATE_KEY_PATH

# Generate public key for host
sudo cat $PRIVATE_KEY_PATH | wg pubkey | sudo tee $PUBLIC_KEY_PATH

# create the config file
CONF_PATH="/etc/wireguard/$WG_NAME.conf"

echo "[INTERFACE]" > $CONF_PATH
echo "PrivateKey = ${sudo cat $PRIVATE_KEY_PATH}" > $CONF_PATH
echo "Address = $ASSIGNED_ADDRESS" > $CONF_PATH

echo "[Peer]"
echo "PublicKey = $WG_SERVER_PUBLIC_KEY" > $CONF_PATH
echo "AllowedIPs = $WG_ALLOWED_IPS" > $CONF_PATH
echo "EndPoint = $WG_ENDPOINT" > $CONF_PATH

