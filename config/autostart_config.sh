#!/usr/bin/env

#START MODE -1 don't start anything
#START MODE 0 start camera driver only ( and use unsync version)
#START MODE 1 start camera and VO
#START MODE 2 start camera VO and controller
#START MODE 3 start camera VO ctrl and uwb comm
#START MODE 4 start camera VO ctrl and uwb comm, uwb fuse

#START MODE 5 start UWB broadcast data vo with control
#START MODE 6 5660 start UWB broadcast vicon and camera driver&TOF; Controle use uwb data
#START MODE 7 5660 start UWB broadcast vicon and camera driver&TOF; Controle use camera data

export SWARM_START_MODE=0
export RECORD_BAG=0
export NODE_ID=2
export CAMERA_ID=25001498

#CAM Type = 0 : Ptgrey
#CAM Type = 1 : MYNT
#CAM Type = 2 : BlueFox
export CAM_TYPE=2
export CAM_ID=25001498
