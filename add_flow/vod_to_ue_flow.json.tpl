{ "flows": [
     { 
       "priority": 6000, 
       "isPermanent": true, 
       "deviceId": "of:%DEVICE_ID%",
       "tableId": 1,
        "treatment": { 
           "instructions": [ 
           { 
             "type": "OUTPUT", 
             "port": "%SGI_PORT_NO%" 
           } 
         ] 
       }, 
         "selector": { 
           "criteria": [ 
           {
             "type": "IN_PORT",
             "port": "%VOD_PORT_NO%"
           },
           {
             "type": "ETH_TYPE",
             "ethType": "0x0800"
           },
           { 
             "type": "IPV4_SRC", 
             "ip": "%VOD_IP%"
           },
           { 
             "type": "IPV4_DST", 
             "ip": "%UE_IPV4_NET%" 
           } 
         ] 
       } 
     } 
   ] 
 }
