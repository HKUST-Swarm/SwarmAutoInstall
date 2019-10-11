#!/bin/bash
echo "will set ip to 10.10.1.$1"
sudo iw wlan0 set power_save off
sudo service network-manager stop
sudo ip link set wlan0 down
sudo ip link set wlan0 up
sudo iwconfig wlan0 mode ad-hoc
sudo iwconfig wlan0 channel 4
sudo iwconfig wlan0 essid 'swarm-mesh-network'
#sudo ip link set wlan0 up
sudo iwconfig wlan0 ap 02:72:C5:C8:D1:BE
sudo ip addr add 10.10.1.$1/24 broadcast 10.10.1.255 dev wlan0


sudo batctl if add wlan0
sudo ip link set up dev bat0
sudo ifconfig bat0 10.10.0.$1/24

sudo alfred -m -i bat0 &
sudo batadv-vis -i bat0 -s &
