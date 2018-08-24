#!/bin/bash
head_ip=$(grep -A1 "Host head1" ~/.ssh/config |grep -v "Host head1"|awk '{print $2}')
echo "${head_ip} head1" | sudo tee -a /etc/hosts
ssh -L 0.0.0.0:8000:head1:80 head1

### WEB UI/username/password
# MAAS: 
#  - url: http://ciab:8000/MAAS/
#  - username: cord
#  - password: cat ~/cord/build/maas/passwords/maas_user.txt
# XOS: 
#  - url: http://ciab:8000/xos
#  - username: xosadmin@opencord.org
#  - password: ssh head1; cat /opt/credentials/xosadmin@opencord.org
# OpenStack: /opt/cord_profile/admin-openrc.sh
# ONOS:
#   - http://ciab:8000/fabric;  onos/rocks ; "apps -a -s", "app activate/deactivate org.opencord.vtn"
#   - http://ciab:8000/vtn;  onos/rocks

### Apache configuration:
# ssh head1; /etc/apache2/conf-available/cord-http.conf
