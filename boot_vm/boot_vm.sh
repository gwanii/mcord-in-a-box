#!/bin/bash
# set -x
# m1.medium | 4096      | 40 | 2
# m1.large  | 8192      | 80 | 4
# mem >= 28G(4*3+8*2)
# disk >= 280G(40*3+80*2)

function bootvm {
    set -x 
    net_ids=$(neutron net-list --sort-key name|grep -E "$4"|awk '{print $2}')
    nics=""
    for net_id in ${net_ids}; do
        nics="--nic net-id=$net_id $nics"
    done
    nova boot \
    --flavor "$2" \
    --image "$3" \
    ${nics} \
    "$1"
}

main() {
bootvm mmehss m1.medium centos-7.2 "management|signaling"
bootvm sgwc m1.medium centos-7.2 "management|signaling|sx_network"
bootvm pgwc m1.medium centos-7.2 "management|signaling|sx_network"
bootvm spgwu m1.large centos-7.2 "management|sx_network|s1u_network|app_network"
bootvm vodapp m1.large vod "app_network"
nova list
}

main
