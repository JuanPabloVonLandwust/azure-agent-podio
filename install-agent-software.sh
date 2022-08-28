#!/bin/bash
# Update the Linux OS
sudo apt update
sudo apt upgrade -y
sudo apt autoremove -y
# Install Node.js
setupFile=nodesource_setup.sh

echo "*** Purging Node.js from the system... ***"
sudo apt purge -y nodejs
if [[ -f  /etc/apt/sources.list.d/nodesource.list ]]; then
    sudo rm -r /etc/apt/sources.list.d/nodesource.list
fi
echo "*** Creating directory ~/Downloads... ***"
mkdir -p ~/Downloads && cd ~/Downloads
echo "*** Downloading Node.js setup file... ***"
curl -sL https://deb.nodesource.com/setup_lts.x -o $setupFile
sudo bash ~/Downloads/nodesource_setup.sh
echo "*** Installing Node.js... ***"
sudo apt install -y nodejs
echo "*** Removing Node.js setup file... ***"
rm ~/Downloads/$setupFile
# Install the Azure Pipelines Agent
version=$VERSION #$1
url=$URL #$2
org=$ORG #$3
token=$TOKEN #$4
name=$NAME #$5
packageName=vsts-agent-linux-x64-$version.tar.gz

if [[ ! -f ~/myagent/.service ]]; then
    if [[ ! -f ~/myagent/config.sh ]]; then
        echo "*** Downloading package $packageName... ***"
        wget https://vstsagentpackage.azureedge.net/agent/$version/$packageName
        echo "*** Creating directory ~/myagent... ***"
        mkdir -p ~/myagent && cd ~/myagent
        echo "*** Extracting package $packageName... ***"
        tar zxvf ~/Downloads/$packageName
        echo "*** Removing package $packageName... ***"
        rm ~/Downloads/$packageName
    fi
    cd ~/myagent
    echo "*** Installing the Azure Pipelines Agent... ***"
    ./config.sh --unattended --acceptTeeEula --url $url$org --auth pat --token $token --agent $name --replace
    echo "*** Installing service... ***"
    sudo ./svc.sh install
    echo "*** Starting service... ***"
    sudo ./svc.sh start
else
    echo "*** The service is already running! :) ***"  
fi