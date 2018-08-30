#!/usr/bin/env bash
echo "Source ing..."
source /opt/ros/kinetic/setup.bash
source /home/dji/swarm_ws/devel/setup.bash

echo "Start ros core"
export ROS_MASTER_URI=http://localhost:11311
roscore > /home/dji/log_roscore.txt&
sleep 5
echo "Start uwb"
roslaunch swarm_vo_fuse stereo.launch is_sync:=false > /home/dji/log_swarm.txt &
PG_PID=$!

sleep 10
kill -9 $PG_PID

roslaunch swarm_vo_fuse swarm_vo_fuse.launch >> /home/dji/log_swarm.txt &
sleep 30
roslaunch cascade_controller mf2_swarm.launch > /home/dji/log_swarm_controller &
/bin/bash /home/dji/SwarmAutoInstall/start_controller.sh
#roslaunch infinity_uwb_ros uwb_node_manifold2.launch > /home/dji/log_uwb.txt & 
