#!/bin/bash
# update onos to 1.13.2, update vtn to 1.6.0
# https://jira.opencord.org/browse/CORD-1878

OLD=1.12.0
NEW=1.13.2
sed -i "s#$OLD#$NEW#g" ~/cord/build/docker_images.yml
grep -rl "$OLD" ~/cord/onos-apps|xargs -I'{}' sed -i "s#$OLD#$NEW#g" '{}'
cd ~/cord/build
rm ib_actions.yml || :
rm ib_graph.dot || :
rm milestones/docker-images || :
rm milestones/publish-docker-images || :
rm milestones/onboard-profile || :
make clean-onos
# 1. comment the mavenrepo at cord/build/docker_images.yml to speed
# 2. clean onos image on corddev/head1
#ssh corddev
#docker rm all verison onos
#docker rmi onosproject/onos:candidate
#docker rmi docker-registry:5000/onosproject/onos:candidate
#ssh head1
#docker rmi xos/onos:candidate
#docker rmi docker-registry:5000/onosproject/onos:candidate
make build


### Operate on ONOS CLI
# app install http://192.168.100.107:8000/cord-config-1.4.0.oar
# app install http://192.168.100.107:8000/vtn-1.6.0.oar
# app activate org.opencord.config
# app activate org.opencord.vtn
# cordvtn-sync-neutron-states https://keystone.cord.lab:5000/v2.0 admin admin piJFV4TC9ExEO3d8bOOy
