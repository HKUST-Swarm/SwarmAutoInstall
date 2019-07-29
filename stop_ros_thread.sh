#!/usr/bin/env bash
while IFS='' read -r line || [[ -n "$line" ]]; do
    IFS=':' inarr=(${line})
    PRS_NAME=${inarr[0]}
    if [ "$PRS_NAME" = "$1"  ]; then
        echo "Killing $line with ${inarr[1]}"
        sudo kill -- ${inarr[1]}
    fi
done < /home/dji/swarm_log_lastest/pids.txt
