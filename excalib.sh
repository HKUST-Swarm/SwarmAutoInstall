#!/usr/bin/env bash

roscore&
ROS_PID=$!

mkdir -p "/home/dji/swarm_log_lastest/left/"
mkdir -p "/home/dji/swarm_log_lastest/right/"

# /home/dji/SwarmAutoInstall/excalib_collectbag.sh

LOG_PATH=/home/dji/swarm_log_lastest

echo "Enabling chicken blood mode"
sudo /usr/sbin/nvpmodel -m0
sudo /home/dji/jetson_clocks.sh

echo "Running vins LEFT"
rosrun vins vins_node /home/dji/SwarmConfig/realsense/realsense_n3_unsync.yaml &
VINS_PID=$!

sleep 3
rosbag play /ssd/calib-bags/stereo_calib.bag
#After bag over, play left tail, then kill

echo "Left VINS RES"
tail -n 10 $LOG_PATH/left/log_vo.txt
echo "\n\n"

kill -- $VINS_PID

sleep 3

echo "Running vins RIGHT"

rosrun vins vins_node /home/dji/SwarmConfig/realsense/realsense_n3_right.yaml &
VINS_PID=$!

sleep 10
rosbag play /ssd/calib-bags/stereo_calib.bag

echo "Right VINS RES"
tail -n 10 $LOG_PATH/left/log_vo.txt
echo "\n\n"
kill -- $VINS_PID

echo "Left ex"
cat $LOG_PATH/left/extrinsic_parameter.csv

echo "Right ex"
cat $LOG_PATH/right/extrinsic_parameter.csv

kill -- $ROS_PID