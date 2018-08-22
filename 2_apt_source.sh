#!/bin/bash
### 1. Change maven source on CiAB server for imagebuilder
### 2. After vagrant vms are up, stop "make build", copy this script to head1, corddev and execute
# then "make build" again
# scp 3_atp_source.sh head1:~/; ssh head1 ./3_apt_source.sh
# scp 3_atp_source.sh corddev:~/; ssh corddev ./3_apt_source.sh

change_maven_source() {
cat <<EOF | tee ~/cord/onos-apps/settings.xml
<settings>
  <localRepository>/mavenwd/repository</localRepository>
  <mirror>
    <id>nexus-aliyun</id>
    <mirrorOf>*</mirrorOf>
    <name>Nexus aliyun</name>
    <url>http://maven.aliyun.com/nexus/content/groups/public</url>
  </mirror>
</settings>
EOF
}

change_apt_source() {
cat <<EOF | sudo tee /etc/apt/sources.list
deb https://mirrors.tuna.tsinghua.edu.cn/ubuntu/ trusty main restricted universe multiverse
# deb-src https://mirrors.tuna.tsinghua.edu.cn/ubuntu/ trusty main restricted universe multiverse
deb https://mirrors.tuna.tsinghua.edu.cn/ubuntu/ trusty-updates main restricted universe multiverse
# deb-src https://mirrors.tuna.tsinghua.edu.cn/ubuntu/ trusty-updates main restricted universe multiverse
deb https://mirrors.tuna.tsinghua.edu.cn/ubuntu/ trusty-backports main restricted universe multiverse
# deb-src https://mirrors.tuna.tsinghua.edu.cn/ubuntu/ trusty-backports main restricted universe multiverse
deb https://mirrors.tuna.tsinghua.edu.cn/ubuntu/ trusty-security main restricted universe multiverse
# deb-src https://mirrors.tuna.tsinghua.edu.cn/ubuntu/ trusty-security main restricted universe multiverse
deb [arch=amd64] https://mirrors.ustc.edu.cn/docker-ce/linux/ubuntu trusty stable
# deb-src [arch=amd64] https://mirrors.ustc.edu.cn/docker-ce/linux/ubuntu trusty stable
EOF
sudo add-apt-repository "deb [arch=amd64] https://mirrors.ustc.edu.cn/docker-ce/linux/ubuntu $(lsb_release -cs) stable"
sudo apt-get update -y
}

change_docker_registry() {
sudo apt-get install -y --force-yes docker-ce=17.06.*
sudo sed -i 's#DOCKER_OPTS="#DOCKER_OPTS="--registry-mirror=https://registry.docker-cn.com #g' /etc/default/docker
sudo service docker restart
}

change_apt_source
change_docker_registry
