#!/bin/bash



a=( 192.168.1.11 192.168.1.21
192.168.1.41
192.168.1.51
192.168.1.1
192.168.1.71
192.168.1.81
192.168.1.91
192.168.1.101
192.168.1.111
192.168.1.121
192.168.1.131
192.168.1.171
192.168.1.31
)

#a=(192.168.1.1)



for i in ${a[@]};
do
	echo $i
#	ssh $i  "cp /etc/sudoers  /opt/APM/;ls /opt/APM"
#	scp /opt/APM/zabbix/zabbix3/etc/zabbix_agentd.conf.d/APM_RQ_monitor.conf  $i:/opt/APM/zabbix/zabbix3-agent/etc/zabbix_agentd.conf.d/APM_RQ_monitor.conf
	ssh $i  "/etc/init.d/zabbix_agentd restart"
done
