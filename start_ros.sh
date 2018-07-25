#!/usr/bin/env bash
echo "Source ing..."
source /opt/ros/kinetic/setup.bash
source /home/dji/swarm_ws/devel/setup.bash

echo "Start ros core"
export ROS_MASTER_URI=http://localhost:11311
roscore > /home/dji/log_roscore.txt&
sleep 5
echo "Start uwb"
roslaunch infinity_uwb_ros uwb_node_manifold2.launch > /home/dji/log_uwb.txt & 
