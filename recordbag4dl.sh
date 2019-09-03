#!/bin/bash
roslaunch mocap_optitrack mocap.launch &
OPTI_PID=$!

sleep 5
rosbag record -o swarm_dl_$1.bag /swarm_mocap/SwarmNodePose0 \
    /swarm_mocap/SwarmNodePose2 \
    /swarm_mocap/SwarmNodePose4 \
    /camera/infra1/image_rect_raw \
    /camera/infra2/image_rect_raw \
    /camera/depth/image_rect_raw

kill -- $OPTI_PID
kill -- $THR_PID
