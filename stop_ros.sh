#!/usr/bin/env bash
while IFS='' read -r line || [[ -n "$line" ]]; do
    IFS=':' inarr=(${line})
    echo "Killing $line with ${inarr[1]}"
    sudo kill -- ${inarr[1]}
done < /home/dji/swarm_log_lastest/pids.txt

echo "Closing fan"
sudo nvpmodel -m 1
sudo /home/dji/jetson_clocks.sh --restore