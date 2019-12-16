#!/bin/bash
echo "will set ip to 10.10.1.$1"
sudo iw wlan0 set power_save off
sudo service network-manager stop
sudo ip link set wlan0 down
sudo ip link set wlan0 up
sudo iwconfig wlan0 mode ad-hoc
sudo ifconfig wlan0 mtu 1560
sudo iwconfig wlan0 channel 13
sudo iwconfig wlan0 essid 'swarm-mesh-network'
#sudo ip link set wlan0 up
sudo iwconfig wlan0 ap 02:72:C5:C8:D1:BE
sudo ip addr add 10.10.1.$1/24 broadcast 10.10.1.255 dev wlan0

ip route add default via 10.10.1.10 dev wlan0
route add  -net 224.0.0.0 netmask 240.0.0.0 dev bat0

sudo chmod a+w /etc/resolv.conf
sudo echo "nameserver 8.8.8.8">/etc/resolv.conf

sleep 1
sudo modprobe batman-adv
sleep 1

sudo batctl if add wlan0
sleep 1
sudo ip link set up dev bat0
sleep 1
sudo ifconfig bat0 10.10.0.$1/24

sleep 1
sudo alfred -m -i bat0 &
sudo batadv-vis -i bat0 -s &


while true; do
    for N in {1..10}
    do
        ping 10.10.0.$N -c 3
    done
done
