# https://wiki.opencord.org/display/CORD/VTN+Manual+Tests#VTNManualTests-Localmanagementnetworktest

neutron net-create net-management
neutron subnet-create net-management 172.27.0.0/24
curl -X POST -H "Content-Type: application/json" -u onos:rocks -d @data.json http://$OC1:8181/onos/cordvtn/serviceNetworks

$ cat data.json
{
    "ServiceNetwork": {
        "id": "UUID of net-management",
        "type": "management_local",
        "providerNetworks": []
    }
}
