sudo ip link add ciabveth1 type veth peer name ciabveth2
sudo ifconfig ciabveth1 up
sudo ifconfig ciabveth2 up
sudo ovs-vsctl add-port leaf1 ciabveth2 

sudo ifconfig ciabveth1 111.0.0.100/24  ## s1u_network
sudo ip addr add 116.0.0.100/24 dev ciabveth1 ## signaling

### add enb to epc flow
#cd add_flow
# ./add_enb_flow.sh # 修改deviceId, mac, ip, output为fabric's ofpno
### arp
# ssh spgwu; arp -s 111.0.0.100 22:de:37:9b:26:52
# ssh mmehss; arp -s 116.0.0.100 22:de:37:9b:26:52

### capture packet on compute fabric nic
# ping -I ciabveth1 111.0.0.3  ## s1u ip
# sudo tcpdump -e -i fabric icmp -vv 

#https://guide.opencord.org/profiles/mcord/enodeb-setup.html
