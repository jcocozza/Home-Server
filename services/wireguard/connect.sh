#!/bin/bash
#
# This will connect a peer to the wireguard server.
# Run it on the peer machine
# Environment variables:
#   WG_NAME

connect_to_wireguard() {
    sudo wg-quick up $1
}

connect_to_wireguard $WG_NAME
