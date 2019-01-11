#!/usr/bin/env bash
read -p "Enter your github passwd $" github_pwd
echo Will use xuhao1 and $github_pwd

SWARM_WS=~/swarm_ws

sudo rm -rf $SWARM_WS
#Create workspace
mkdir -p $SWARM_WS/src
cd $SWARM_WS/src
#git clone git@github.com:HKUST-Aerial-Robotics/infinity_uwb_ros.git
git clone https://github.com/xuhao1/ptgrey_reader.git
git clone https://xuhao1:$github_pwd@github.com/xuhao1/swarm_pkgs.git
git clone https://github.com/xuhao1/camera_calibration_frontend.git
git clone -b UltraFast https://xuhao1:$github_pwd@github.com/HKUST-Aerial-Robotics/VINS_Stereo.git
#git clone https://xuhao1:$github_pwd@github.com/xuhao1/mocka.git

cd $SWARM_WS/src/ptgrey_reader
sudo ./script/autoinstall_tx2.sh

cd ~/swarm_ws
catkin_make
