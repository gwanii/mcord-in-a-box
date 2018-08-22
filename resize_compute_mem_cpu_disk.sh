#!/bin/bash
cd ~/cord/build

# resize mem cpu
echo "compute_vm_cpu: 12" >> ./podconfig/mcord-ng40-virtual.yml
echo "compute_vm_mem: 51200" >> ./podconfig/mcord-ng40-virtual.yml
rm genconfig/config.yml
make PODCONFIG=mcord-ng40-virtual.yml config
VAGRANT_CWD=./scenarios/cord/ vagrant reload compute1

# resize disk
# vi ~/cord/build/scenarios/cord/Vagrantfile; v.machine_virtual_size
VAGRANT_CWD=./scenarios/cord/ vagrant halt compute1
sudo qemu-img resize /var/lib/libvirt/images/cord_compute1-vdb.qcow2 +300G
VAGRANT_CWD=./scenarios/cord/ vagrant up compute1
