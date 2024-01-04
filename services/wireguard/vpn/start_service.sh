#!/bin/bash
#
# This will start wireguard on the machine it is run on.
#
# Environment variables:
#   WG_NAME

connect_to_wireguard() {
    sudo wg-quick up $1
}

connect_to_wireguard $WG_NAME
