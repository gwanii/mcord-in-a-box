# for ubuntu 14.04 vhost_net is disable by default, to improve time delay this options should be enabled
# on ciab server
sed -i "s#^VHOST_NET_ENABLED=.*#VHOST_NET_ENABLED=1#g" /etc/default/qemu-kvm
# on compute node
sed -i "s#^VHOST_NET_ENABLED=.*#VHOST_NET_ENABLED=1#g" /etc/default/qemu-kvm
