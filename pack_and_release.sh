#!/usr/bin/env bash
cd /home/dji
rm swarm_ws_pack.zip
zip -r /home/dji/swarm_ws_pack.zip swarm_ws -x *.git*
md5sum swarm_ws_pack.zip
