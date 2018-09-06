#!/bin/bash
set -x
flowdir=/home/ubuntu/add_flow
logdir="$flowdir"
enb_ip=%ENODEB_IP%
ue_ipv4_net=%UE_IPV4_NET%

(test -d "$flowdir" && \
 test -r "$flowdir"/add_flow.sh && \
 test -r "$flowdir"/s1mme_to_enb_flow.json && \
 test -r "$flowdir"/ue_to_vod_flow.json && \
 test -r "$flowdir"/vod_to_ue_flow.json) || exit 0

log () {
  echo "$@" >> "${logdir}/add-flow.log"
}

add_flow () {
  log $(date)
  while :; do
    log "wait onos connected..."
    ovs-vsctl show|grep -q "is_connected: true" && break
  done
  log "onos is connected."

  while :; do
    log "wait onos rest api port opened..."
    nc -z 10.1.0.1 8102 && break
  done
  log "onos rest api served at 10.1.0.1:8102."

  while :; do
    c_enb=$(ovs-ofctl dump-flows br-int | grep -c "$enb_ip")
    c_ue=$(ovs-ofctl dump-flows br-int | grep -c "$ue_ipv4_net")
    if [[ x"$c_enb" != x"1" ]] || [[ x"$c_ue" != x"2" ]]; then
      pushd "$flowdir"
      ./add_flow.sh
      popd "$flowdir"
      log "adding mcord flows..."
    else
      break
    fi
  done
  log "mcord flows is added."
}

add_flow

