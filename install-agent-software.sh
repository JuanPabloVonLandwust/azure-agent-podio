#!/bin/bash
# Update the Linux OS
sudo apt update
sudo apt upgrade -y
sudo apt autoremove -y
# Package names
nodeSetupFile=nodesource_setup.sh
chromeSetupFile=google-chrome-stable_current_amd64.deb
edgeSetupFile=microsoft-edge-stable_105.0.1343.53-1_amd64.deb
# Remove previous versions of the packages
echo "*** Purging Node.js from the system... ***"
sudo apt purge -y nodejs
if [[ -f  /etc/apt/sources.list.d/nodesource.list ]]; then
    sudo rm -r /etc/apt/sources.list.d/nodesource.list
fi
echo "*** Purging Google Chrome from the system... ***"
sudo apt purge -y google-chrome-stable
echo "*** Purging Microsoft Edge from the system... ***"
sudo apt purge -y microsoft-edge-stable
echo "*** Purging Mozilla Firefox from the system... ***"
sudo apt purge -y firefox
echo "*** Removing no longer required packages... ***"
sudo apt autoremove -y
echo "*** Creating directory ~/Downloads... ***"
mkdir -p ~/Downloads && cd ~/Downloads
# Install Node.js
echo "*** Downloading Node.js setup file... ***"
curl -sL https://deb.nodesource.com/setup_lts.x -o $nodeSetupFile
sudo bash ~/Downloads/$nodeSetupFile
echo "*** Installing Node.js... ***"
sudo apt install -y nodejs
node --version
npm --version
echo "*** Removing Node.js setup file... ***"
rm ~/Downloads/$nodeSetupFile
# Install Google Chrome
echo "*** Downloading Google Chrome setup file... ***"
wget https://dl.google.com/linux/direct/$chromeSetupFile
echo "*** Installing Google Chrome... ***"
sudo apt install -y ~/Downloads/$chromeSetupFile
google-chrome --version
echo "*** Removing Google Chrome setup file... ***"
rm ~/Downloads/$chromeSetupFile
# Install Microsoft Edge
echo "*** Downloading Microsoft Edge setup file... ***"
wget https://packages.microsoft.com/repos/edge/pool/main/m/microsoft-edge-stable/$edgeSetupFile
echo "*** Installing Microsoft Edge... ***"
sudo apt install -y ~/Downloads/$edgeSetupFile
microsoft-edge --version
echo "*** Removing Microsoft Edge setup file... ***"
rm ~/Downloads/$edgeSetupFile
# Install Mozilla Firefox
echo "*** Installing Mozilla Firefox... ***"
sudo apt install -y firefox
firefox --version
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
