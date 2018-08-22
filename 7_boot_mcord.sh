#!/bin/bash
### Boot M-CORD
#https://guide.opencord.org/cord-4.1/profiles/mcord/installation_guide.html
curl -u xosadmin@opencord.org:BGj8xNXIJoxiAtLukowH -X POST http://head1/xosapi/v1/vepc/vepcserviceinstances -H "Content-Type: application/json" -d '{"blueprint":"build", "site_id": 1}'
#curl -u xosadmin@opencord.org:BGj8xNXIJoxiAtLukowH -X DELETE http://head1/xosapi/v1/vepc/vepcserviceinstances/1
