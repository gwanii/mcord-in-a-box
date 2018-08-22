#!/bin/bash
sudo apt-get install -y tmux
# tmux attach
# run below commands in tmux session
cp mcord-ng40-virtual.yml ~/cord/build/podconfig/mcord-ng40-virtual.yml
cd ~/cord/build
make PODCONFIG=mcord-ng40-virtual.yml config
make -j4 build

### debug
# ssh -L 5902:localhost:5902 ubuntu@ciab
# vncviewer :5902
# ssh head1; less /var/log/maas/maas.log
# ssh head1; less /etc/maas/ansible/logs/node-dfdfdfdfdfsfdfd.log

### validate
# VAGRANT_CWD=./scenarios/cord/ vagrant status
# ssh head1; sudo lxc list (check all running)
# ssh head1; cord prov list
# ssh head1; source /opt/cord_profile/admin-openrc.sh; nova hypervisor-list

# ssh head1; ssh -p 8101 onos@onos-fabric (pass: rocks)
# ssh head1; ssh -p 8102 onos@onos-cord (pass: rocks); cordvtn-nodes/cordvtn-networks
# if error, try:
#onos> cordvtn-sync-neutron-states https://keystone.cord.lab:5000/v2.0 admin admin piJFV4TC9ExEO3d8bOOy (/opt/cord_profile/admin-openrc.sh)
#onos> cordvtn-sync-xos-states xos-chameleon.cord.lab:9101 xosadmin@opencord.org Cb4R1vJ2wIU38pZQFtgo (/opt/credentials/xosadmin@opencord.org)
#如果状态不为COMPLETE, 执行cordvtn-node-init
