#!/bin/bash
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
bootvm epc-c m1.medium centos-7.2 "management|signaling|sx_network"
bootvm epc-u m1.large centos-7.2 "management|signaling|sx_network|app_network"
bootvm vodapp m1.large centos-7.2 "management|app_network"
nova list
}

main
#bootvm test m1.medium centos-7.2 "management"
