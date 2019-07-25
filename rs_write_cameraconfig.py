#!/usr/bin/python
import rospy
from sensor_msgs.msg import CameraInfo


def write_to_file(info, fn):
    fx = info.K[0]
    cx = info.K[2]
    fy = info.K[4]
    cy = info.K[5]

    k1 = info.D[0]
    k2 = info.D[1]
    p1 = info.D[2]
    p2 = info.D[3]
    k3 = info.D[4]
    config = """%YAML:1.0
---
model_type: PINHOLE
camera_name: camera
image_width: {}
image_height: {}
distortion_parameters:
   k1: {}
   k2: {}
   p1: {}
   p2: {}
projection_parameters:
   fx: {}
   fy: {}
   cx: {}
   cy: {}
""".format(info.width, info.height, k1, k2, p1, p2, fx, fy, cx, cy)
    f = open(fn, "w")
    f.write(config)
    f.close()

if __name__ == "__main__":
    rospy.init_node("rs_write_cameraconfig")
    rospy.loginfo("Waiting for infra1")
    infra1_info = rospy.wait_for_message("/camera/infra1/camera_info", CameraInfo)
    rospy.loginfo("Waiting for infra2")
    infra2_info = rospy.wait_for_message("/camera/infra2/camera_info", CameraInfo)

    #rospy.loginfo("Waiting for color")
    #color_info = rospy.wait_for_message("/camera/color/camera_info", CameraInfo)

    rospy.loginfo("Write infra1 to left")
    write_to_file(infra1_info, "/home/dji/SwarmConfig/realsense/left.yaml")
    rospy.loginfo("Write infra2 to right")
    write_to_file(infra2_info, "/home/dji/SwarmConfig/realsense/right.yaml")
    #rospy.loginfo("Write color")
    #write_to_file(color_info, "/home/dji/SwarmConfig/realsense/color.yaml")
    rospy.loginfo("Finish camera param writing")
