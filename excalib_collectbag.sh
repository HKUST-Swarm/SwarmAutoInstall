#!/usr/bin/env bash

echo "Collecting bag for excalibration"
/home/dji/SwarmAutoInstall/stop_ros.sh
/home/dji/SwarmAutoInstall/start_ros.sh 0

sleep 10
mkdir -p /ssd/calib-bags
#Collecting data
# rosrun vins vins_node /home/dji/SwarmConfig/realsense/realsense_n3_left.yaml 
echo "Move your drone now!"
rosbag record -O /ssd/calib-bags/stereo_calib.bag /camera/infra1/camera_info /camera/infra1/image_rect_raw /camera/infra2/camera_info /camera/infra2/image_rect_raw /dji_sdk_1/dji_sdk/imu
stop_ros.sh