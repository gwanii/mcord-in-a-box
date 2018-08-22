### CORD-in-a-Box 使用及维护

#### 1. head节点登录方式

先登录到ciab物理机: ssh ubuntu@192.168.107.200(用户密码: ubuntu/ciab),

在ciab物理机上登录head1: ssh head1, 

在head1上可查看虚拟机: nova list --all-tenants

#### 2. openstack虚拟机登录方式

先登录到ciab物理服务器, 然后登录到head1(ssh head1)

再登录到计算节点(ssh ubuntu@noted-water.cord.lab)

然后执行: ssh epc-c(ssh 后直接指定虚拟机名称, 比如epc-c, epc-u, vodapp)

#### 3. 虚拟机操作

先登录到ciab物理服务器, 然后登录到head1(ssh head1)

再登录到计算节点(ssh ubuntu@noted-water.cord.lab)

```
删除虚拟机:
$ nova delete <vm>

使用脚本boot_vm.sh新建虚拟机:
$ ./boot_vm.sh
boot_vm.sh内容如下:
$ cat boot_vm.sh
#!/bin/bash
# set -x
# m1.medium | 4096      | 40 | 2
# m1.large  | 8192      | 80 | 4
# mem >= 28G(4*3+8*2)
# disk >= 280G(40*3+80*2)

function bootvm {
    set -x 
    net_ids=$(neutron net-list --sort-key name|grep -E "$4"|awk '{print $2}')
    nics=""
    for net_id in ${net_ids}; do
        nics="--nic net-id=$net_id $nics"
    done
    nova boot \
    --flavor "$2" \
    --image "$3" \
    ${nics} \
    "$1"
}

main() {
bootvm epc-c m1.medium centos-7.2 "management|signaling|sx_network"
bootvm epc-u m1.medium centos-7.2 "management|signaling|sx_network|app_network"
bootvm vodapp m1.medium centos-7.2 "management|app_network"
nova list
}

main
```

#### 4. ONOS升级

登录ciab物理服务器,

```
$ cat ./upgrade_onos.sh
#!/bin/bash
# upgrade ONOS to 1.13.2, upgrade VTN to 1.6.0
# https://jira.opencord.org/browse/CORD-1878

OLD=1.12.0  # 旧的ONOS版本
NEW=1.13.2  # 新的ONOS版本
sed -i "s#$OLD#$NEW#g" ~/cord/build/docker_images.yml
grep -rl "$OLD" ~/cord/onos-apps|xargs -I'{}' sed -i "s#$OLD#$NEW#g" '{}'
cd ~/cord/build
rm ib_actions.yml || :
rm ib_graph.dot || :
rm milestones/docker-images || :
rm milestones/publish-docker-images || :
rm milestones/onboard-profile || :
make clean-onos

# comment the mavenrepo at cord/build/docker_images.yml to speed image building procedure

# clean onos image on corddev/head1
ssh corddev docker rmi onosproject/onos:candidate
ssh corddev docker rmi docker-registry:5000/onosproject/onos:candidate
ssh head1 docker rmi xos/onos:candidate
ssh head1 docker rmi docker-registry:5000/onosproject/onos:candidate

make build

# 下载ONOS APP oar文件， 启动HTTP server
# wget https://oss.sonatype.org/service/local/repositories/releases/content/org/opencord/vtn/1.6.0/vtn-1.6.0.oar
# wget https://oss.sonatype.org/service/local/repositories/releases/content/org/opencord/cord-config/1.4.0/cord-config-1.4.0.oar
# 将cord-config-14.0.oar和vtn-1.6.0.oar放到一个http服务器的文件目录下, 可以使用命令"python -mSimpleHTTPServer"启HTTP服务器

# 最后, 安装ONOS APP, 以下需在head1上执行:
# ssh -p 8102 onos@onoc-cord
# app install http://192.168.100.107:8000/cord-config-1.4.0.oar
# app install http://192.168.100.107:8000/vtn-1.6.0.oar
# app activate org.opencord.config
# app activate org.opencord.vtn
# cordvtn-sync-neutron-states https://keystone.cord.lab:5000/v2.0 admin admin piJFV4TC9ExEO3d8bOOy
```
