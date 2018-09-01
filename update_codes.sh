#!/usr/bin/env bash

SWARM_WS=~/swarm_ws
function update_ros_code {
    cd $SWARM_WS/src/$1
    git pull -f 
}

update_ros_code swarm_pkgs