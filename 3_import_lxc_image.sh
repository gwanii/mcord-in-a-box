#!/bin/bash
# pull image
# sudo lxc image copy ubuntu:xenial local: --alias trusty
# export image
# sudo lxc image export ubuntu:xenial .
# import image


# on ciab server
cd ~/cord/build
cp create_lxd_main.yml ./platform-install/roles/create-lxd/tasks/main.yml

# on head1
ssh head1
sudo lxc image import meta-08bc9273b77e3a604f31b0768400b5287463c3cb326d9eaf41fb465b9b3b7aed.tar.xz 08bc9273b77e3a604f31b0768400b5287463c3cb326d9eaf41fb465b9b3b7aed.tar.xz --alias trusty
