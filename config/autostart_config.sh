#!/usr/bin/env

#START MODE -1 don't start anything
#START MODE 0 start camera driver only ( and use unsync version)
#START MODE 1 start camera and VO
#START MODE 2 start camera VO and controller
#START MODE 3 start camera VO ctrl and uwb comm
#START MODE 4 start camera VO ctrl and uwb comm, uwb fuse
export SWARM_START_MODE=3
export RECORD_BAG=0
export NODE_ID=2

#CAM Type = 0 : Ptgrey
#CAM Type = 1 : MYNT
export CAM_TYPE=1
