#!/bin/bash
#sudo ovs-ofctl add-flow br-int "priority=5000,ip,nw_dst=172.27.0.100 actions=mod_dl_dst:22:de:37:9b:26:52,output:2"
curl -u "onos:rocks" -X POST "http://localhost:8182/onos/v1/flows" -H "Content-Type: application/json" -H "Accept: application/json" -d @./s1mme_to_enb_flow.json >> flow_added
echo >> flow_added
#curl -u "onos:rocks" -X POST "http://localhost:8182/onos/v1/flows" -H "Content-Type: application/json" -H "Accept: application/json" -d @./s1u_to_enb_flow.json >> flow_added
