#!/bin/bash
#
# Install wireguard
#
# Environment variables
#   BASE_USER
#   WG_SERVER_IP
#   WG_SERVER_VPN_IP

python3 exports.py
source exports.sh

machines=("$@")  ## List of ip addresses

echo "########## Setting up wireguard server ##########"

echo "Installing wireguard on $WG_SERVER_IP..."
ssh -t "$BASE_USER"@"$WG_SERVER_IP" "sudo apt update; sudo apt install wireguard"

scp exports.sh "$BASE_USER@$WG_SERVER_IP:exports.sh"
scp services/wireguard/vpn/setup_server_configuration.sh "$BASE_USER@$WG_SERVER_IP:/tmp/setup_server_configuration.sh"

echo "Setting up server config on $WG_SERVER_IP..."
ssh -t "$BASE_USER"@"$WG_SERVER_IP" "source exports.sh; bash /tmp/setup_server_configuration.sh $WG_SERVER_VPN_IP"

echo "########## Finished setting up wireguard server ##########"

echo "########## Adding machines to wireguard server ##########"
server_public_key=$(bash services/wireguard/vpn/get_server_public_key.sh)

for ipaddr in "${machines[@]}"; do
    if [[ "$ipaddr" != "$WG_SERVER_IP" ]]; then
        echo "Installing wireguard on $ipaddr..."
        ssh -t "$BASE_USER"@"$ipaddr" "sudo apt update; sudo apt install wireguard"

        echo "Setting up peer $ipaddr"
        scp exports.sh "$BASE_USER@$ipaddr:exports.sh"
        scp services/wireguard/vpn/setup_peer_configuration.sh "$BASE_USER@$ipaddr:/tmp/setup_peer_configuration.sh"
        scp services/wireguard/vpn/add_peer_to_server.sh "$BASE_USER@$ipaddr:/tmp/add_peer_to_server.sh"

        assigned_vpn_ip=$(python3 services/wireguard/vpn/get_assigned_ip.py $ipaddr)
        echo "$ipaddr is assigned vpn address $assigned_vpn_ip"

        echo "Setting up peer config for $ipaddr..."
        ssh -t "$BASE_USER"@"$ipaddr" "source exports.sh; bash /tmp/setup_peer_configuration.sh $assigned_vpn_ip $server_public_key"

        echo "Adding peer $ipaddr to $WG_SERVER_IP..."
        ssh -t "$BASE_USER"@"$ipaddr" "source exports.sh; bash /tmp/add_peer_to_server.sh $assigned_vpn_ip"

    fi
done
echo "########## Finished adding machines to wireguard server ##########"
