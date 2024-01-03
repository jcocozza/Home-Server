#!/bin/bash
#
# This will disconnect a peer to the wireguard server.
# Run it on the peer machine
# Environment variables:
#   WG_NAME

disconnect_to_wireguard() {
    sudo wg-quick down $1
}

disconnect_to_wireguard $WG_NAME
