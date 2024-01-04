#!/bin/bash
#
# Stop the actual server

echo "killing actual server"
cd actual-server &&
forever stop app.js