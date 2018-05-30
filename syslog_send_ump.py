#!/usr/bin/env python
#-*-coding:utf-8-*-


import socket,re
from sys import argv

sendto = argv[1]
subject = argv[2]
msg = argv[3]
#UMP syslog probe server host&port
host = '10.1.71.82'
port = 514


#APM

APM = ['FLUME','KAFKA','ES','COLLECTOR','ZOOKEEPER']


msg_list = msg.split("|")
#
patt = re.compile(r'(\w+)')

msg_list[11] = patt.match(msg_list[11]).group(1).upper()
#msg_list[11]app
if msg_list[11] in APM:
	#msg_list[10]
	msg_list[10] = 'APM'
	msg_list[9] = 'APP'
else:
	msg_list[10] = 'LINUX'
	msg_list[9] = 'OS'
	msg_list[11] = 'PERFORMANCE'

#ALERT_OBJECT = msg_list[10]-msg_list[11]
msg_list[7] = msg_list[10]+"-"+msg_list[11]
# = zabbix-msg_list[9]-msg_list[10]-msg_list[11]_M
msg_list[6] = "ZABBIX-"+msg_list[9]+"-"+msg_list[10]+"-"+msg_list[11]

send_msg = '|'.join(msg_list)
#echo info for test.
print(send_msg)

s=socket.socket(socket.AF_INET,socket.SOCK_DGRAM)
s.sendto(send_msg,(host,port))

