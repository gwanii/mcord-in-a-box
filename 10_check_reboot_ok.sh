### 1. on ciab server
# set vm autorestart
virsh autostart cord_corddev
virsh autostart cord_head1
virsh autostart cord_compute1
virsh list --autostart
# set network autorestart
virsh net-autostart cord0
virsh net-autostart cordmgmt
virsh net-autostart default
virsh net-autostart vagrant-libvirt
# to check failure
ls /etc/libvirt/qemu/networks/
ls /etc/libvirt/qemu/networks/autostart/
tail -f /var/log/libvirt/libvirtd.log

# set em2 auto up
cat >>EOF| sudo tee -a /etc/network/interfaces
auto em2
iface em2 inet manual
  ovs_bridge leaf1
  ovs_type OVSPort
EOF


### 2. on head1
# add "resume_guests_state_on_boot=True" to nova-compute's configuration
juju set nova-compute config-flags=nova.virt.firewall.NoopFirewallDriver,resume_guests_state_on_host_boot=True
juju get nova-compute|grep -A 5 config-flags
# check config on compute node
# cat /var/lib/juju/./agents/unit-nova-compute-0/charm/.juju-persistent-config|grep resume_guests_state_on_host_boot=True


# 3. on compute
# cp add_flow to compute
cp add_flow/mcord-flow /etc/init.d/mcord-flow
chown root:root /etc/init.d/mcord-flow && chmod +x /etc/init.d/mcord-flow
update-rc.d mcord-flow defaults

# set br-int static ip
cat <<EOF | sudo tee -a /etc/network/interfaces
auto br-int
iface br-int inet static
  address 172.27.0.1
  network 172.27.0.0
  netmask 255.255.255.0
EOF

# 4. on epc-c vm
cat <<EOF > /etc/ethters
116.0.0.130 00:00:00:02:0a:67
EOF
cat <<EOF > /sbin/ifup-local
#!/bin/bash
arp -f /etc/ethters
EOF
chmod +x /sbin/ifup-local

# 5. on epc-u vm
# insert this three lines into /usr/loca/bin/ovs-init.sh,  before while loop at the ending of file
ip netns exec ns1 ifconfig veth2 hw ether fa:16:3e:67:a5:fa  # s1u port
ip netns exec ns1 ifconfig veth4 hw ether fa:16:3e:26:d3:86  # sgi port
ip netns exec ns1 arp -s 116.0.0.130 00:00:00:02:0a:67 # this line should at the next of mac change action and ifconfig action

# 6. on vodapp vm
# on vodapp vm(ubuntu 16.04)
cat <<EOF > /etc/network/interfaces.d/50-cloud-init.cfg
auto lo
iface lo inet loopback

auto ens3
iface ens3 inet dhcp
  post-up /sbin/ip route add 10.100.0.0/24 via 119.0.0.4
  post-up /sbin/ethtool -K ens3 tx off
EOF

# 7. disable and mask cloud-init on all vm
systemctl mask cloud-init && systemctl disable cloud-init
