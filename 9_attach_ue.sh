# on head1
ssh head1
cd add_flow
./add_to_enb.sh  # s1u/s1-mme to enb flow
./add_ue_to_vod_flow.sh  # ue to vod flow, uplink between epc-u and vodapp
./add_vod_to_ue_flow.sh  # vod to ue flow, downlink between epc-u and vodapp

# on epc-c vm
arp -s 116.0.0.130 00:00:00:02:0a:67

# on epc-u vm
ssh epc-u
ip netns exec ns1 ifconfig veth2 hw ether fa:16:3e:67:a5:fa  # change vs1u mac to s1u mac
ip netns exec ns1 ifconfig veth4 hw ether fa:16:3e:26:d3:86  # change vsgi mac to sgi mac
# static arp should be added after mac address change
ip netns exec ns1 arp -s 116.0.0.130 00:00:00:02:0a:67

# on vodapp vm
ip route add 10.100.0.0/24 via 118.0.0.2 dev eth0

# test ping from ue to vod

# install vod, must without management nic of vod vm
# ssh root@epc-u  (without mangement nic, log in from epc-u vm)
# ssh ip netns exec ns1 ssh root@118.0.0.4  (vod' ip at app network)
