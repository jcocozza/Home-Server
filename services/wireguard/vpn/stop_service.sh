#!/bin/bash
#
# This stop wireguard on the machine it is run on.
#
# Environment variables:
#   WG_NAME

disconnect_to_wireguard() {
    sudo wg-quick down $1
}

disconnect_to_wireguard $WG_NAME
