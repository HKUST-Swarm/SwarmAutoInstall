#!/bin/bash
rosrun mocap_optitrack UWBViconClient.py &
OPTI_PID=$!
sleep 3
rosbag record -o sf.bag /swarm_drones/swarm_frame \
    /swarm_drones/swarm_frame_without_detection \
    /vins_estimator/imu_propagate \
    /vins_estimator/odometry \
    /swarm_mocap/SwarmNodeOdom0 \
    /swarm_mocap/SwarmNodeOdom1 \
    /swarm_mocap/SwarmNodeOdom2 \
    /swarm_mocap/SwarmNodeOdom3 \
    /swarm_mocap/SwarmNodeOdom4 \
    /swarm_mocap/SwarmNodeOdom5 \
    /swarm_mocap/SwarmNodeOdom6 \
    /swarm_mocap/SwarmNodeOdom7 \
    /swarm_mocap/SwarmNodeOdom8 \
    /swarm_mocap/SwarmNodeOdom9

kill -- $!
