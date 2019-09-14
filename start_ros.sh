#!/usr/bin/env bash
# echo "$(whoami)"

[ "$UID" -eq 0 ] || exec sudo "$0" "$@"

echo "Sourceing..."
source /opt/ros/kinetic/setup.bash
source /home/dji/swarm_ws/devel/setup.bash

export ROS_MASTER_URI=http://localhost:11311

LOG_PATH=/home/dji/swarm_log/`date +%F_%T`
CONFIG_PATH=/home/dji/SwarmConfig

source $CONFIG_PATH/autostart_config.sh

if [ "$#" -ge 1 ]; then
    export SWARM_START_MODE=$1
    echo "Start swarm with MODE" $1
fi
if [ $SWARM_START_MODE -ge 0 ]
then
    sudo mkdir -p $LOG_PATH
    sudo chmod a+rw $LOG_PATH
    sudo rm /home/dji/swarm_log_lastest
    ln -s $LOG_PATH /home/dji/swarm_log_lastest

    PID_FILE=/home/dji/swarm_log_lastest/pids.txt
    touch $PID_FILE
    echo "Start ros core"
    roscore &> $LOG_PATH/log_roscore.txt &
    echo "roscore:"$! >> $PID_FILE
    #Sleep 5 wait for core
    sleep 5

    echo "Will start camera"
    export START_CAMERA=1
    export START_UWB_COMM=0
    export START_CONTROL=0
    export START_CAMERA_SYNC=0
    export START_UWB_FUSE=0
    export START_DJISDK=1
    export START_VO_STUFF=0
    export START_UWB_VICON=0
    export USE_VICON_CTRL=0
    export USE_DJI_IMU=0

    if [ $SWARM_START_MODE -ge 1 ]
    then
        echo "Will start VO"
        START_VO_STUFF=1
        START_CAMERA_SYNC=1
        if [ $CAM_TYPE -eq 3 ]
        then
            USE_DJI_IMU=1
        fi
    fi

    if [ $SWARM_START_MODE -ge 2 ]
    then
        echo "Will start Control"
        START_CONTROL=1
    fi

    if [ $SWARM_START_MODE -ge 3 ]
    then
        echo "Will start UWB COMM"
        START_UWB_COMM=1
    fi

    if [ $SWARM_START_MODE -ge 4 ]
    then
	    echo "Will start UWB FUSE"
	    START_UWB_FUSE=1
    fi

    if [ $SWARM_START_MODE -eq 5 ]
    then
        echo "Will start Control with VICON odom and disable before"
        START_CONTROL=1
        START_UWB_VICON=1
        START_DJISDK=1
        USE_VICON_CTRL=1

        START_CAMERA=0
        START_UWB_COMM=0
	    START_UWB_FUSE=0
        START_VO_STUFF=0
        START_CAMERA_SYNC=0
    fi

    if [ $SWARM_START_MODE -eq 9 ]
    then
        echo "Use for record bag for dl"
        START_CONTROL=0
        START_UWB_VICON=0
        START_DJISDK=1
        USE_VICON_CTRL=1

        START_CAMERA=1
        START_UWB_COMM=1
	    START_UWB_FUSE=0
        START_VO_STUFF=0
        START_CAMERA_SYNC=0

    fi

    if [ $START_CAMERA -eq 1 ]  && [ $CAM_TYPE -eq 0  ]  ||  [ $START_CONTROL -eq 1  ] || [ $USE_DJI_IMU -eq 1 ]
    then
        export START_DJISDK=1
        echo "Using Ptgrey Camera, USE DJI IMUor using control, will boot dji sdk"
    fi

else
    exit 0
fi


# if [ $START_CAMERA -eq 1 ] || [ $START_UWB_FUSE -eq 1]
# then
    # echo "Is using VO or VO FUSE, enabling chicken blood mode"
echo "Enabling chicken blood mode"
sudo /usr/sbin/nvpmodel -m0
sudo /home/dji/jetson_clocks.sh
# fi

if [ $START_DJISDK -eq 1 ]
then
    roslaunch dji_sdk sdk.launch &> $LOG_PATH/log_sdk.txt &
    echo "DJISDK:"$! >> $PID_FILE
fi



if [ $START_CAMERA -eq 1 ]
then
    echo "Trying to start camera driver"
    if [ $CAM_TYPE -eq 0 ]
    then
        echo "Will use pointgrey Camera"
        echo "Start Camera in unsync mode"
        #roslaunch swarm_vo_fuse stereo.launch is_sync:=false config_path:=$CONFIG_PATH/camera_config.yaml &> $LOG_PATH/log_camera.txt &
        PG_PID=$!
        echo "PTGREY_UNSYNC:"$! >> $PID_FILE
        if [ $START_CAMERA_SYNC -eq 1 ]
        then
            sleep 5
            sudo kill -- $PG_PID
            echo "Start camera in sync mode"
            sleep 1.0
            #roslaunch swarm_vo_fuse stereo.launch is_sync:=true config_path:=$CONFIG_PATH/camera_config.yaml &>> $LOG_PATH/log_camera.txt &
            echo "PTGREY_SYNC:"$! >> $PID_FILE
        fi
    fi

    if [ $CAM_TYPE -eq 1 ]
    then
        echo "Will use MYNT Camera"
        source /home/dji/source/MYNT-EYE-S-SDK/wrappers/ros/devel/setup.bash
        roslaunch mynt_eye_ros_wrapper mynteye.launch request_index:=1 &> $LOG_PATH/log_camera.txt &
        echo "MYNT_CAMERA:"$! >> $PID_FILE
        sleep 2
    fi

    if [ $CAM_TYPE -eq 2 ]
    then
        echo "Will use bluefox Camera"
        roslaunch bluefox2 single_node.launch device:=$CAMERA_ID &> $LOG_PATH/log_camera.txt &
        echo "BLUEFOX:"$! >> $PID_FILE
    fi

    if [ $CAM_TYPE -eq 3 ]
    then
        echo "Will use realsense Camera"
        roslaunch realsense2_camera rs_camera.launch  &> $LOG_PATH/log_camera.txt &
        echo "writing camera config"
        #/home/dji/SwarmAutoInstall/rs_write_cameraconfig.py
        rosrun dynamic_reconfigure dynparam set /camera/stereo_module 'emitter_enabled' false
        echo "REALSENSE:"$! >> $PID_FILE
    fi
fi

if [ $START_VO_STUFF -eq 1 ]
then
    sleep 10
    echo "Image ready start VO"
    if [ $CAM_TYPE -eq 0 ]
    then
        echo "No ptgrey VINS imple yet"
        # roslaunch vins_estimator dji_stereo.launch config_path:=$CONFIG_PATH/dji_stereo/dji_stereo.yaml &> $LOG_PATH/log_vo.txt &
    fi

    if [ $CAM_TYPE -eq 1 ]
    then
        taskset -c 1-4 rosrun vins vins_node /home/dji/SwarmConfig/mini_mynteye_stereo/mini_mynteye_stereo_imu.yaml &> $LOG_PATH/log_vo.txt &
        echo "VINS:"$! >> $PID_FILE
    fi

    if [ $CAM_TYPE -eq 3 ]
    then
        taskset -c 1-4 rosrun vins vins_node /home/dji/SwarmConfig/realsense/realsense_n3_unsync.yaml &> $LOG_PATH/log_vo.txt &
        echo "VINS:"$! >> $PID_FILE
    fi
fi

if [ $START_UWB_VICON -eq 1 ]
then
    echo "Start UWB VO"
    roslaunch mocap_optitrack mocap_uwbclient.launch &> $LOG_PATH/log_uwb_mocap.txt &
fi

if [ $START_UWB_COMM -eq 1 ]
then
    roslaunch localization_proxy uwb_comm.launch &> $LOG_PATH/log_comm.txt &
    echo "SWARM_UWB_COMM:"$! >> $PID_FILE
fi

if [ $START_UWB_FUSE -eq 1 ]
then

    #roslaunch swarm_detection swarm_detect.launch &> $LOG_PATH/log_swarm_detection.txt &
    taskset -c 5-6 roslaunch swarm_yolo drone_detector.launch &> $LOG_PATH/log_swarm_detection.txt &
    echo "SWARM_DETECT:"$! >> $PID_FILE
    taskset -c 5-6 roslaunch swarm_localization local-5-drone.launch &> $LOG_PATH/log_swarm.txt &
    echo "SWARM_LOCAL:"$! >> $PID_FILE
fi

if [ $START_CONTROL -eq 1 ]
then
    if [ $USE_VICON_CTRL -eq 1 ]
    then
        echo "Start drone_commander with VICON"
        roslaunch drone_commander commander.launch vo_topic:=/uwb_vicon_odom &> $LOG_PATH/log_drone_commander.txt &
        echo "drone_commander:"$! >> $PID_FILE
        echo "Start position ctrl with VICON"
        roslaunch drone_position_control pos_control_vicon.launch vo_topic:=/uwb_vicon_odom &> $LOG_PATH/log_drone_position_ctrl.txt &
        echo "drone_pos_ctrl:"$! >> $PID_FILE

    else
        echo "Start drone_commander"
        roslaunch drone_commander commander.launch &> $LOG_PATH/log_drone_commander.txt &
        echo "drone_commander:"$! >> $PID_FILE
        echo "Start position ctrl"
        roslaunch drone_position_control pos_control.launch &> $LOG_PATH/log_drone_position_ctrl.txt &
        echo "drone_pos_ctrl:"$! >> $PID_FILE
    fi

    echo "Start SwarmPilot"
    rosrun swarm_pilot swarm_pilot_node &> $LOG_PATH/log_swarm_pilot.txt &
    echo "swarm_pilot:"$! >> $PID_FILE

fi

if [ $RECORD_BAG -eq 1 ]
then
    rosbag record -o /ssd/bags/swarm_vicon_bags/swarm_log.bag /vins_estimator/imu_propagate /vins_estimator/odometry \
        /swarm_drones/swarm_drone_fused /swarm_drones/swarm_drone_fused_relative /swarm_drones/swarm_frame /swarm_drones/swarm_frame_predict /uwb_node/time_ref \
        /swarm_drones/swarm_drone_basecoor \
        /swarm_drones/est_drone_0_odom \
        /swarm_drones/est_drone_1_odom \
        /swarm_drones/est_drone_2_odom \
        /swarm_drones/est_drone_3_odom \
        /swarm_drones/est_drone_4_odom &
    echo "rosbag:"$! >> $PID_FILE

fi

if [ $RECORD_BAG -eq 2 ]
then
    rosbag record -o $LOG_PATH/swarm_source_log.bag /swarm_drones/swarm_frame /swarm_drones/swarm_frame_predict /vins_estimator/imu_propagate /vins_estimator/odometry
fi
