/usr/bin/env bash
echo "Start ros"
sudo -S sh -c 'echo 2048 > /sys/module/usbcore/parameters/usbfs_memory_mb'
/bin/bash /home/dji/SwarmAutoInstall/start_ros.sh &

