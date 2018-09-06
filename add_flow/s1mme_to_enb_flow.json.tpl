{ "flows": [
     { 
       "priority": 5000, 
       "isPermanent": true, 
       "deviceId": "%DEVICE_ID%",
       "tableId": 4,
        "treatment": { 
           "instructions": [ 
           {
     	     "type": "L2MODIFICATION",
             "subtype": "ETH_DST",
             "mac": "%ENODEB_MAC%"
           },
           { 
             "type": "OUTPUT", 
             "port": "%FABRIC_PORT_NO%" 
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
             "ip": "%ENODEB_IP%/32"
           } 
         ] 
       } 
     } 
   ] 
 }
