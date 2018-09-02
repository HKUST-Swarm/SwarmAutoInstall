echo "Start swarm controller "
while true; do
	roslaunch cascade_controller mf2_swarm.launch
	sleep 5
done
