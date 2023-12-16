#!/bin/bash
#
# This script will add a peer to a wireguard server - run it on the machine hosting the wireguard server
#
# Environment Variables:
#   WIREGUARD_PATH
#   WG_NAME
#   WG_ALLOWED_IPS
#

PEER_NAME="$1"
PEER_PUBLIC_KEY="$2"

# Add peer to the conf file
CONF_PATH="$WIREGUARD_PATH/$WG_NAME.conf"

echo "[Peer]" >> $CONF_PATH
echo "# Name = $PEER_NAME" >> $CONF_PATH
echo "PublicKey = $PEER_PUBLIC_KEY" >> $CONF_PATH
echo "AllowedIPs = $WG_ALLOWED_IPS" >> $CONF_PATH
