#!/bin/bash
source /opt/cord_profile/admin-openrc.sh
source ./bootstrap_var
fabric_port_name=fabric

echo_v() {
  echo ">>> $1: ${!1}"
}

get_vm_ip() {
  local vm=$1
  local net=$2
  echo $(nova show "$vm"|grep "$net"|awk '{print $5}')
}

get_vm_mac_by_ip() {
  local ip=$1
  echo $(neutron port-list|grep "$ip"|awk '{print $5}')
}

get_portno() {
  field=$1
  value=$2
  echo $(echo "rocks"|sshpass ssh -p 8102 onos@onos-cord ports 2>/dev/null|grep "${field}=${value}"|awk 'match($0, /port=([1-9][0-9]*),/, group) {print group[1]}')
}

get_device_id() {
  compute_node_ip=$1
  echo $(echo "rocks"|sshpass ssh -p 8102 onos@onos-cord devices 2>/dev/null|grep "managementAddress=$compute_node_ip"|awk 'match($0, /id=(of:[a-z0-9]{16}),/, group) {print group[1]}')
}

get_vm_portno_by_mac() {
  local mac=$(echo "$1"|sed 's/^fa/fe/g')
  echo $(get_portno portMac $mac)
}

get_vm_portno() {
  local vm=$1
  local net=$2

  ip=$(get_vm_ip "$vm" "$net")
  mac=$(get_vm_mac_by_ip "$ip")
  echo $(get_vm_portno_by_mac "$mac")
}

get_portno_by_name() {
  local name=$1
  echo $(get_portno portName $name)
}

show_var() {
  echo "### show variables"
  echo_v vm_epc_c
  echo_v vm_epc_u
  echo_v vm_vod
  echo_v s1u_net
  echo_v sgi_net
  echo_v enodeb_ip
  echo_v enodeb_mac
  echo_v ue_ipv4_net
  echo_v compute_node_ip

  s1u_ip=$(get_vm_ip "$vm_epc_u" "$s1u_net")
  s1u_mac=$(get_vm_mac_by_ip "$s1u_ip")
  echo_v s1u_mac
  sgi_ip=$(get_vm_ip "$vm_epc_u" "$sgi_net")
  echo_v sgi_ip
  sgi_mac=$(get_vm_mac_by_ip "$sgi_ip")
  echo_v sgi_mac
  sgi_port_no=$(get_vm_portno_by_mac "$sgi_mac")
  echo_v sgi_port_no
  vod_ip=$(get_vm_ip "$vm_vod" "$sgi_net")
  echo_v vod_ip
  vod_mac=$(get_vm_mac_by_ip "$vod_ip")
  vod_port_no=$(get_vm_portno_by_mac "$vod_mac")
  echo_v vod_port_no
  fabric_port_no=$(get_portno_by_name "$fabric_port_name")
  echo_v fabric_port_no
  compute_device_id=$(get_device_id "$compute_node_ip")
  echo_v compute_device_id
}

onboard_var() {
  for f in *.tpl; do cp "$f" $(basename "$f" ".tpl"); done
  sed -i -e"s#%ENODEB_IP%#$enodeb_ip#g" -e"s#%UE_IPV4_NET%#$ue_ipv4_net#g" ./mcord-flow
  sed -i -e"s#%DEVICE_ID%#$compute_device_id#g" -e"s#%ENODEB_MAC%#$enodeb_mac#g" -e"s#%ENODEB_IP%#$enodeb_ip#g" -e"s#%FABRIC_PORT_NO%#$fabric_port_no#g" ./s1mme_to_enb_flow.json
  sed -i -e"s#%DEVICE_ID%#$compute_device_id#g" -e"s#%VOD_PORT_NO%#$vod_port_no#g" -e"s#%SGI_PORT_NO%#$sgi_port_no#g" -e"s#%UE_IPV4_NET%#$ue_ipv4_net#g" ./ue_to_vod_flow.json
  sed -i -e"s#%DEVICE_ID%#$compute_device_id#g" -e"s#%SGI_PORT_NO%#$sgi_port_no#g" -e"s#%VOD_PORT_NO%#$vod_port_no#g" -e"s#%VOD_IP%#$vod_ip#g" -e"s#%UE_IPV4_NET%#$ue_ipv4_net#g" ./vod_to_ue_flow.json
  sed -i -e"s#%ENODEB_IP%#$enodeb_ip#g" -e"s#%ENODEB_MAC%#$enodeb_mac#g" -e"s#%S1U_MAC%#$s1u_mac#g" -e"s#%SGI_IP%#$sgi_ip#g" -e"s#%SGI_MAC%#$sgi_mac#g" -e"s#%UE_IPV4_NET%#$ue_ipv4_net#g" persist_network_config.txt
  sed -i -e"s#%DEVICE_ID%#$compute_device_id#g" ./del_to_enb_flow.sh
}

main() {
  show_var
  onboard_var
}

main
