#!/bin/bash
# Download code
curl -o ~/cord-bootstrap.sh https://raw.githubusercontent.com/opencord/cord/cord-4.1/scripts/cord-bootstrap.sh
chmod +x cord-bootstrap.sh
./cord-bootstrap.sh -v

# Download ng40 License
# https://guide.opencord.org/cord-4.1/profiles/mcord/installation_guide.html
# cp ng40-license ~/cord/orchestration/xos_services/venb/xos/synchronizer/files/ng40-license


# Download glance images
# curl -sSL -o image-venb https://github.com/opencord/venb/releases/download/vms/ng40-vmcord-1-4GB.img.20171201
# echo "3d6d385247560c90db90b2591578c200eafaa62c232a964ab664420e8b2b33ac image-venb" | sha256sum -c
# curl -sSL -o image-spgwc http://www.vicci.org/cord/ngic-cp1-cmpress.qcow2.20171121
# echo "eca43de006d193625778597cc9b3f171752c31e0ce6dbed363954c87c33935a3 image-spgwc" | sha256sum -c
# curl -sSL -o image-spgwu http://www.vicci.org/cord/ngic-dp1-cmpress.qcow2.20171121
# echo "2d431dc24b8de5d531ddf9a82c20f692d9ac8c9d4dd0295c535acc06c6635bc5 image-spgwu" | sha256sum -c

# Comment "Download Glance VM images" ./platform-install/roles/glance-images/tasks/main.yml
cp ./glance-images-playbook.yml ~/cord/build/platform-install/glance-images-playbook.yml
# Copy all images to head1 vm's directory /opt/images/
# ls image-* |xargs -I'{}' mv '{}' '{}'.qcow2
# scp image-* head1:/opt/images/

# Change retries
cd ~/cord/build
grep -rl "retries" --include=*.yml .|xargs sed -i -e 's#retries: .*$#retries: 1000#g'
