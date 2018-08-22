#!/bin/bash
docker rmi docker-registry:5000/onosproject/onos:candidate
docker rmi onosproject/onos:candidate
docker rmi xos/onos:candidate
