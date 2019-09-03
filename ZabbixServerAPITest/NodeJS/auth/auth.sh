#!/bin/bash
echo "Zabbix API auth"
curl http://192.168.1.116/api_jsonrpc.php -v -X POST -H "Content-Type: application/json-rpc" -d @auth.json > authResult.json
cat authResult.json
echo ""
