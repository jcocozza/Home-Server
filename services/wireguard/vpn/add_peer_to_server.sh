#!/bin/bash
#
# This script will add a peer to a wireguard server - run it on the machine hosting the wireguard server
#
# Environment Variables:
#   WIREGUARD_PATH
#   WG_NAME
#   WG_SERVER_IP

assigned_vpn_ip="$1"
PEER_NAME=$(hostname)
PEER_PUBLIC_KEY=$(sudo cat $WIREGUARD_PATH/public.key)

# Add peer to the conf file
CONF_PATH="$WIREGUARD_PATH/$WG_NAME.conf"

peer="[Peer]
# Name = $PEER_NAME
PublicKey = $PEER_PUBLIC_KEY
AllowedIPs = $assigned_vpn_ip/32"

#echo "$peer" | sudo tee -a "$CONF_PATH" > /dev/null
ssh -t "$BASE_USER"@"$WG_SERVER_IP" "echo '$peer' | sudo tee -a '$CONF_PATH' > /dev/null"

