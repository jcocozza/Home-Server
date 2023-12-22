#!/bin/bash
#
# This script will install a paper minecraft server on the machine

# check for java installation
java_version=$(java -version 2>&1)
if [[ "$java_version" == *"OpenJDK 17"* && "$java_version" == *"JRE Headless"* ]]; then
    echo "OpenJDK 17 JRE Headless is installed."
else
    echo "OpenJDK 17 JRE Headless is not installed."
    echo "This is needed to run the server. Installing..."
    sudo apt install openjdk-17-jre-headless
fi



mkdir papermc
cd papermc

# install the server stuff
wget https://api.papermc.io/v2/projects/paper/versions/1.20.2/builds/318/downloads/paper-1.20.2-318.jar
mv paper-1.20.2-318.jar paper.jar

java -Xms2G -Xmx2G -jar paper.jar --nogui &
pid=$!
wait "$pid"

# accept eula
sed -i 's/eula=false/eula=true/' eula.txt

# run server for real this time
java -Xms2G -Xmx2G -jar paper.jar --nogui &
