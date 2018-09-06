{ "flows": [
     { 
       "priority": 6000, 
       "isPermanent": true, 
       "deviceId": "%DEVICE_ID%",
       "tableId": 1,
        "treatment": { 
           "instructions": [ 
           { 
             "type": "OUTPUT", 
             "port": "11" 
           } 
         ] 
       }, 
         "selector": { 
           "criteria": [ 
           {
             "type": "IN_PORT",
             "port": "%SGI_PORT_NO%"
           },
           {
             "type": "ETH_TYPE",
             "ethType": "0x0800"
           },
           { 
             "type": "IPV4_SRC", 
             "ip": "%UE_IPV4_NET%" 
           }
        ] 
       } 
     } 
   ] 
 }
