# on compute node
# edit /etc/nova/nova.conf, add resume_guests_state_on_host_boot=True
# cp ../add_flow to compute node's /home/ubuntu/add_flow
cp add_flow/mcord-flow /etc/init.d/mcord-flow
chown root:root /etc/init.d/mcord-flow
chmod +x /etc/init.d/mcord-flow

# on epc-c vm
cat <<EOF > /etc/ethters
%ENODEB_IP% %ENODEB_MAC%
EOF
cat <<EOF > /sbin/ifup-local
#!/bin/bash
arp -f /etc/ethters
EOF
chmod +x /sbin/ifup-local

# on epc-u vm
# insert this three lines into /usr/loca/bin/ovs-init.sh,  before while loop at the ending of file
ip netns exec ns1 ifconfig veth2 hw ether %S1U_MAC%  # s1u port
ip netns exec ns1 ifconfig veth4 hw ether %SGI_MAC%  # sgi port
ip netns exec ns1 arp -s %ENODEB_IP% %ENODEB_MAC% # this line should at the next of mac change action

# on vodapp vm
cat <<EOF > /etc/init.d/settx.sh 
#! /bin/sh
ip route add %UE_IPV4_NET% via %SGI_IP%
ethtool -K %VOD_NIC% tx off
EOF
chown root:root /etc/init.d/settx.sh
chmod +x /etc/init.d/settx.sh
