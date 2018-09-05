# on compute
# edit /etc/nova/nova.conf, add resume_guests_state_on_host_boot=True
# cp add_flow to compute
cp add_flow/mcord-flow /etc/init.d/mcord-flow
chown root:root /etc/init.d/mcord-flow
chmod +x /etc/init.d/mcord-flow

# on epc-c vm
cat <<EOF > /etc/ethters
116.0.0.130 00:00:00:02:0a:67
EOF
cat <<EOF > /sbin/ifup-local
#!/bin/bash
arp -f /etc/ethters
EOF
chmod +x /sbin/ifup-local

# on epc-u vm
# insert this three lines into /usr/loca/bin/ovs-init.sh,  before while loop at the ending of file
ip netns exec ns1 ifconfig veth2 hw ether fa:16:3e:67:a5:fa  # s1u port
ip netns exec ns1 ifconfig veth4 hw ether fa:16:3e:26:d3:86  # sgi port
ip netns exec ns1 arp -s 116.0.0.130 00:00:00:02:0a:67 # this line should at the next of mac change action

# on vodapp vm
cat <<EOF > /etc/init.d/settx.sh 
#! /bin/sh
ip route add 10.100.0.0/24 via 118.0.0.2
ethtool -K ens3 tx off
EOF
chown root:root /etc/init.d/settx.sh
chmod +x /etc/init.d/settx.sh
