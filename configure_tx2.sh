#!/bin/bash
#Install git
cd ~
echo "Cloning Swarm auto install"
git clone https://github.com/xuhao1/SwarmAutoInstall
cd SwarmAutoInstall
./auto_install.sh
