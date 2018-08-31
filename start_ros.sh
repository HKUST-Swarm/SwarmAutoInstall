#!/usr/bin/env bash
echo "Sourceing..."
source /opt/ros/kinetic/setup.bash
source /home/dji/swarm_ws/devel/setup.bash

export ROS_MASTER_URI=http://localhost:11311

LOG_PATH=/home/dji/swarm_log/`date +%F_%T`

source /home/dji/SwarmAutoInstall/autostart_config.sh  

if [ $SWARM_START_MODE -ge 0 ]
then
    mkdir -p $LOG_PATH
    echo "Start ros core"
    roscore > $LOG_PATH/log_roscore.txt 2>$LOG_PATH/log_roscore_error.txt &
    #Sleep 5 wait for core
    sleep 5
    
    echo "Will start camera"
    export START_CAMERA=1
    export START_UWB_STUFF=0
    export START_VO_STUFF=0
    export START_CONTROL=0
    export START_CAMERA_SYNC=0

    if [ $SWARM_START_MODE -ge 1 ]
    then
        echo "Will start VO"
        export START_VO_STUFF=1
        export START_CAMERA_SYNC=1
    fi

    if [ $SWARM_START_MODE -ge 2 ]
    then
        echo "Will start UWB"
        export START_UWB_STUFF=1
    fi

    if [ $SWARM_START_MODE -ge 3 ]
    then
        echo "Will start Control"
        export START_CONTROL=1
    fi
fi



if [ $START_CAMERA -eq 1 ]
then
    echo "Start Camera in unsync mode"
    roslaunch swarm_vo_fuse stereo.launch is_sync:=false > $LOG_PATH/log_camera.txt 2>>$LOG_PATH/log_error_camera.txt &
    PG_PID=$!
    if [ $START_CAMERA_SYNC -eq 1 ]
    then
        sleep 10
        kill -9 $PG_PID
        echo "Start camera in sync mode"
        roslaunch swarm_vo_fuse stereo.launch is_sync:=true >> $LOG_PATH/log_camera.txt 2>>$LOG_PATH/log_error_camera.txt&
    fi
fi

if [ $START_VO_STUFF -eq 1 ]
then
    echo "Enable chicken blood mode"
    /home/dji/jetson_clocks.sh
    roslaunch djisdkwrapper sdk.launch >> $LOG_PATH/log_sdk.txt 2>>$LOG_PATH/log_error_sdk.txt&
    echo "sleep 10 for djisdk boot up"    
    sleep 10
    roslaunch vins_estimator dji_stereo.launch >> $LOG_PATH/log_vo.txt 2>>$LOG_PATH/log_error_vo &
fi
    
if [ $START_UWB_STUFF -eq 1 ]
then
    roslaunch swarm_vo_fuse swarm_vo_fuse.launch bag_path:="$LOG_PATH" >> $LOG_PATH/log_swarm.txt 2>>$LOG_PATH/log_uwb_error.txt &
fi

if [ $START_CONTROL -eq 1 ]
then
    #Should sleep 15 for controller
    sleep 15
    /home/dji/SwarmAutoInstall/start_controller.sh >> $LOG_PATH/log_contoller.txt 2>>$LOG_PATH/log_contol_error.txt&
fi

