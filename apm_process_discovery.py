#!/bin/env python

#
#
import re,json

f = open('/opt/APM/zabbix/alertscripts/conf/APM_PRO.conf','r')
f_lines=f.readlines()

R_LIST = []
f.close()
for i in f_lines:
	pattern = re.compile(r'(.*)\=(.*$)')
	P_KEY=pattern.match(i)

	PRO_LIST = list(P_KEY.group(2).split(","))
	if not PRO_LIST[0]:
		exit() 
	K_LIST = []
	
	if  'PRO_NAME' == P_KEY.group(1):
		for p in PRO_LIST:
			R_LIST.append({'{#PRONAME}':p})
	elif P_KEY.group(1) == 'GC_PRO':
		for p in PRO_LIST:
                        R_LIST.append({'{#GC_NAME}':p})

print(json.dumps({"data":R_LIST},sort_keys=True,indent=4))
