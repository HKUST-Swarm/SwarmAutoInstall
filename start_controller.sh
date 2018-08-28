echo "Start swarm controller "
while true; do
	roslaunch cascade_controller mf2_swarm.launch > /home/dji/log_swarm_controller
	sleep 5
done
