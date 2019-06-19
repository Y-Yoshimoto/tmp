#!/bin/bash
echo "Zabbix API auth"
curl http://centos7ks/api_jsonrpc.php -X POST -H "Content-Type: application/json-rpc" -d @auth.json > authResult.json
cat authResult.json
