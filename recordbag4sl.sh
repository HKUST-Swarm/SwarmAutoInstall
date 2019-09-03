#!/bin/bash
#roslaunch mocap_optitrack mocap.launch &
#rosrun mocap_optitrack UWBViconClient.py &
#OPTI_PID=$!
sleep 3
rosbag record -o swarm_$1.bag /vins_estimator/imu_propagate \
    /vins_estimator/odometry \
    /swarm_mocap/SwarmNodePose0 \
    /swarm_mocap/SwarmNodePose1 \
    /swarm_mocap/SwarmNodePose2 \
    /swarm_mocap/SwarmNodePose3 \
    /swarm_mocap/SwarmNodePose4 \
    /swarm_mocap/SwarmNodePose5 \
    /swarm_mocap/SwarmNodePose6 \
    /swarm_mocap/SwarmNodePose7 \
    /swarm_mocap/SwarmNodePose8 \
    /swarm_mocap/SwarmNodePose9 \
    /swarm_detection/armarker_detected \
    /swarm_detection/relative_pose_001 \
    /swarm_detection/relative_pose_002 \
    /swarm_detection/relative_pose_003 \
    /swarm_detection/relative_pose_004 \
    /swarm_detection/relative_pose_005 \
    /swarm_detection/relative_pose_006 \
    /swarm_detection/relative_pose_007 \
    /swarm_detection/relative_pose_008 \
    /swarm_detection/relative_pose_009 \
    /swarm_detection/swarm_detected \
    /uwb_node/remote_nodes \
    /uwb_node/time_ref \
    /uwb_node/incoming_broadcast_data \
    /camera/infra1/image_rect_raw \
    /camera/infra2/image_rect_raw \
    /camera/depth/image_rect_raw

#kill -- $OPTI_PID
