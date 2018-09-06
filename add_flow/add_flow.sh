#!/bin/bash
curl -u "onos:rocks" -X POST "http://onos-cord.cord.lab:8182/onos/v1/flows" -H "Content-Type: application/json" -H "Accept: application/json" -d @./s1mme_to_enb_flow.json > flow_added
echo >> flow_added
curl -u "onos:rocks" -X POST "http://onos-cord.cord.lab:8182/onos/v1/flows" -H "Content-Type: application/json" -H "Accept: application/json" -d @./vod_to_ue_flow.json >> flow_added
echo >> flow_added
curl -u "onos:rocks" -X POST "http://onos-cord.cord.lab:8182/onos/v1/flows" -H "Content-Type: application/json" -H "Accept: application/json" -d @./ue_to_vod_flow.json >> flow_added
