#!/usr/bin/env python
# -*- coding: utf-8 -*-
import requests
import json

# 基本環境変数
REDMINEURL = 'http://127.0.0.1/redmine/'
REDMINEUSER = 'admin'
REDMINEPASSWORD = 'adminadmin'

# チケット表示
accessURL = REDMINEURL + 'issues/1.json'
issues1 = requests.get(accessURL, auth=(REDMINEUSER, REDMINEPASSWORD))
# print issues1.status_code
# print issues1.encoding
# print json.dumps(issues1.text, ensure_ascii=False)
#print issues1.text.encode('utf-8')

with open('newisses.json', 'r') as f:
	json_dict = json.load(f)
	print json_dict
# issues2 = json.dumps(json_dict, ensure_ascii=False)
issues2 = json.dumps(json_dict)

print type(issues2)
accessURL_post = REDMINEURL + 'issues.json'
# headers = {'Content-Type': 'application/json'}
post = requests.post(accessURL_post, data= issues2, headers={'Content-Type': 'application/json'} , auth=(REDMINEUSER, REDMINEPASSWORD))
print post.status_code
f.close()