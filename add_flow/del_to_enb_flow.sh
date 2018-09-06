#!/bin/bash
#sudo ovs-ofctl add-flow br-int "priority=5000,ip,nw_dst=172.27.0.100 actions=mod_dl_dst:22:de:37:9b:26:52,output:2"
#curl -u onos:rocks http://localhost:8182/onos/v1/flows|python -m json.tool|less
device_id=%DEVICE_ID%
for fid in $(cat flow_added |awk -F\" '{print $(NF-1) }'); do
curl -I -u "onos:rocks" -X DELETE "http://localhost:8182/onos/v1/flows/$device_id/$fid"
done
