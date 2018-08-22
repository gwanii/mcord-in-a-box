#!/bin/bash

# management 172.27.0.0/24 (already exists)
# s1u_network 111.0.0.0/24 (already exists)
# signaling 116.0.0.0/24
# sx_network 118.0.0.0/24
# app_network 119.0.0.0/24

# create network and subnet
function create_net {
    neutron net-create "$1"
    neutron subnet-create --name "$1"_subnet "$1" "$2"
}

main() {
create_net signaling 116.0.0.0/24
create_net sx_network 118.0.0.0/24
create_net app_network 119.0.0.0/24
neutron net-list
}

main
