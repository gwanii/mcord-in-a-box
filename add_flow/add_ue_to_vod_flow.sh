#!/bin/bash
curl -u "onos:rocks" -X POST "http://localhost:8182/onos/v1/flows" -H "Content-Type: application/json" -H "Accept: application/json" -d @./ue_to_vod_flow.json >> flow_added
echo >> flow_added
