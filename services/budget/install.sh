#!/bin/bash
#
# Install the actual budget server

# install nvm form nodejs management
curl -o- https://raw.githubusercontent.com/nvm-sh/nvm/v0.39.7/install.sh | bash
export NVM_DIR="$HOME/.nvm"
[ -s "$NVM_DIR/nvm.sh" ] && \. "$NVM_DIR/nvm.sh"  # This loads nvm
[ -s "$NVM_DIR/bash_completion" ] && \. "$NVM_DIR/bash_completion"  # This loads nvm bash_completion

source ~/.bashrc

nvm install v20.10.0
npm install --global yarn

# install actual
git clone https://github.com/actualbudget/actual-server.git
cd actual-server


COUNTRY="US"
STATE="."
LOCALITY="."
ORGANIZATION="."
ORG_UNIT="."
COMMON_NAME="."

openssl req -x509 -nodes -days 365 -newkey rsa:2048 -keyout selfhost.key -out selfhost.crt -subj "/C=$COUNTRY/ST=$STATE/L=$LOCALITY/O=$ORGANIZATION/OU=$ORG_UNIT/CN=$COMMON_NAME"

# to be able to see the server on other lan machines we need to set up https
json_content='{
  "https": {
    "key": "selfhost.key",
    "cert": "selfhost.crt"
  }
}'
echo "$json_content" > config.json

yarn install
