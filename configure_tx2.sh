#!/bin/bash
#Install git
cd ~
echo "Delete Auto Install now"
rm -rf SwarmAutoInstall
echo "Cloning Swarm auto install"
git clone https://github.com/xuhao1/SwarmAutoInstall
cd SwarmAutoInstall
./auto_install.sh
