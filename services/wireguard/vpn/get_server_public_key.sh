#!/bin/bash
#
# echo the server's public key
#
# Environment Variables
#   BASE_USER
#   WIREGUARD_SERVER_IP
#   WIREGUARD_PATH

public_key=$(ssh -t "$BASE_USER"@"$WG_SERVER_IP" "sudo cat $WIREGUARD_PATH/public.key")
echo $public_key
