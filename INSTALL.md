### CORD-in-a-Box 安装指南

#### 1. 安装操作系统

raid: raid 5

os: ubuntu 14.04 server

至少两块网卡, 12+ CPU cores, 200GB+ disk, 100GB+ RAM

#### 2. 更改ubuntu镜像源

分别在ciab物理服务器，corddev vm 和 head1 vm上执行以下命令：
```
$ cat <<EOF | sudo tee /etc/apt/sources.list
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
$ sudo add-apt-repository "deb [arch=amd64] https://mirrors.ustc.edu.cn/docker-ce/linux/ubuntu $(lsb_release -cs) stable"
$ sudo apt-get update -y
```

#### 3. 下载安装文件
```
curl -o ~/cord-bootstrap.sh https://raw.githubusercontent.com/opencord/cord/cord-4.1/scripts/cord-bootstrap.sh
cd ~ && chmod +x cord-bootstrap.sh
./cord-bootstrap.sh -v
```

#### 4. 开始安装
```
$ echo 'ubuntu ALL=(ALL) NOPASSWD:ALL' | sudo tee --append /etc/sudoers.d/90-cloud-init-users
$ cp mcord-ng40-virtual.yml ~/cord/build/podconfig/mcord-ng40-virtual.yml
$ cd ~/cord/build
$ make PODCONFIG=mcord-ng40-virtual.yml config
$ grep -rl "retries" --include=*.yml .|xargs sed -i -e 's#retries: .*$#retries: 1000#g'
$ make -j4 build
```

#### 5. 组网调试

1> 基站直连到ciab服务器第二块网卡(假设名称为em2);
登录到ciab物理机: ssh ubuntu@192.168.107.200(用户密码: ubuntu/ciab);
执行以下命令将em2加到leaf1桥上:
```
$ sudo ovs-vsctl add-port leaf1 em2
```

2> 添加ONOS流表
先登录到ciab物理服务器, 然后登录到head1(ssh head1)
```
文件enb_s1mme_flow.json为eNodeB到s1-mme, s1u(使用同一网段)的流表, 需要更改DPID, eNodeB MAC和eNodeB IP,
br-int的DPID可以命令行登录到ONOS查询: ssh onos@onos-cord, 用户密码为onos/rocks, 执行命令“devices”查DPID
$ cat enb_s1mme_flow.json
{ "flows": [
     {
       "priority": 5000,
       "isPermanent": true,
       "deviceId": "of:0000525400321918",  # ---> br-int DPID
       "tableId": 4,
        "treatment": {
           "instructions": [
           {
     	     "type": "L2MODIFICATION",
             "subtype": "ETH_DST",
             "mac": "22:de:37:9b:26:52"  # ---> eNodeB MAC
           },
           {
             "type": "OUTPUT",
             "port": "2"  # ---> fabric port's ofpno
           }
         ]
       },
         "selector": {
           "criteria": [
           {
             "type": "ETH_TYPE",
             "ethType": "0x0800"
           },
           {
             "type": "IPV4_DST",
             "ip": "116.0.0.100/32"  # ---> eNodeB IP
           }
         ]
       }
     }
   ]
 }

使用curl命令添加流表:
$ curl -u "onos:rocks" -X POST "http://localhost:8182/onos/v1/flows" -H "Content-Type: application/json" -H "Accept: application/json" -d @./enb_s1mme_flow.json
```

3> 分别在epc-c和epc-u虚拟机上添加静态arp条目
先登录到ciab物理服务器, 然后登录到head1(ssh head1)
再登录到计算节点(ssh ubuntu@noted-water.cord.lab)
```
ssh epc-c arp -s <enb_ip> <enb_mac>
ssh epc-u arp -s <enb_ip> <enb_mac>
```
