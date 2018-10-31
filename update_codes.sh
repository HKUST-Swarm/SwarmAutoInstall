#!/usr/bin/env bash
source ~/.bashrc
SWARM_WS=~/swarm_ws
function update_ros_code {
    echo Will pull $1
    cd $SWARM_WS/src/$1
    git pull -f 
}

cd /home/dji/SwarmAutoInstall
git pull -f
update_ros_code swarm_pkgs
update_ros_code VINS_Stereo
update_ros_code mocka

cd $SWARM_WS/
catkin_make
