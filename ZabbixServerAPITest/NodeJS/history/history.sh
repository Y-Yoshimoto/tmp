#!/bin/bash
echo "Zabbix API history"
curl http://centos7ks/api_jsonrpc.php -X POST -H "Content-Type: application/json-rpc" -d @historyGet.json > historyResult.json
cat historyResult.json
