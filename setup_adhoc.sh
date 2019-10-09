#!/bin/bash
echo "will set ip to 10.10.1.$1"
sudo iw wlan0 set power_save off
sudo service network-manager stop
sudo ip link set wlan0 down
sudo ip link set wlan0 up
sudo iwconfig wlan0 mode ad-hoc
sudo iwconfig wlan0 channel 4
sudo iwconfig wlan0 essid 'SwarmNet'
sudo ip link set wlan0 up
sudo iwconfig wlan0 ap 32:72:C5:C8:D1:BE
sudo ip addr add 10.10.1.$1/24 dev wlan0


