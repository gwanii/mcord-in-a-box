#!/bin/bash
cd ~/cord/build
pushd milestones
for target in vagrant-up vagrant-ssh-install copy-cord cord-config copy-config prep-headnode maas-prime publish-maas-images deploy-maas publish-docker-images start-xos deploy-mavenrepo deploy-onos prep-computenode deploy-openstack setup-ciab-pcu setup-automation compute1-up; do
  rm $target || true
done
popd
make build
