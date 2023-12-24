#!/bin/bash
#
# Install the actual budget server

# install nvm form nodejs management
curl -o- https://raw.githubusercontent.com/nvm-sh/nvm/v0.39.7/install.sh | bash
source ~/.bashrc

nvm install v20.10.0

npm install --global yarn

# install actual
git clone https://github.com/actualbudget/actual-server.git
cd actual-server
yarn install

# to be able to see the server on other lan machines we need to set up https
openssl req -x509 -nodes -days 365 -newkey rsa:2048 -keyout selfhost.key -out selfhost.crt
json_content='{
  "https": {
    "key": "selfhost.key",
    "cert": "selfhost.crt"
  }
}'
echo "$json_content" > config.json

