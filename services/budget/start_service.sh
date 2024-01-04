#!/bin/bash
#
# start the actual server

echo "starting actual server..."

cd actual-server &&
source ~/.nvm/nvm.sh &&
yarn install
npm install forever -g
forever start app.js
