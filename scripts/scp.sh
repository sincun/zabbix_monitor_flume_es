#!/bin/bash


a=( 192.168.1.11 192.168.1.21 192.168.1.31
192.168.1.41
192.168.1.51
192.168.1.71
192.168.1.1
192.168.1.81
192.168.1.91
192.168.1.101
192.168.1.111
192.168.1.121
192.168.1.131
192.168.1.171
)

#a=(192.168.1.1)



for i in ${a[@]};
do
	echo $i
#	scp /opt/APM/zabbix/zabbix3/etc/zabbix_agentd.conf.d/APM_RQ_monitor.conf $i:/opt/APM/zabbix/zabbix3-agent/etc/zabbix_agentd.conf.d/
#	scp java_yggc.sh  $i:`pwd`
	#	ssh $i "ls /opt/APM/zabbix/alertscripts/|grep -v bak|grep -v conf|grep -v scp.sh|grep -v monitor_kafka.sh|xargs -i mv /opt/APM/zabbix/alertscripts/{} /opt/APM/zabbix/alertscripts/bak/;mv /opt/APM/zabbix/alertscripts/monitor_kafka.sh /opt/APM/zabbix/alertscripts/kafka_monitor.sh"
	#	cd /opt/APM/zabbix/alertscripts
	#	scp *.sh $i:/opt/APM/zabbix/alertscripts
#		ssh $i "rm -rf /opt/APM/zabbix/zabbix3-agent/etc/zabbix_agentd.conf.d/*"
#		scp /opt/APM/zabbix/zabbix3/etc/zabbix_agentd.conf.d/zabbix_apm.conf  $i:/opt/APM/zabbix/zabbix3-agent/etc/zabbix_agentd.conf.d/
	#	scp *.py $i:/opt/APM/zabbix/alertscripts	#	scp *.pl $i:/opt/APM/zabbix/alertscripts
	ssh $i "echo Timeout=20 >> /opt/APM/zabbix/zabbix3-agent/etc/zabbix_agentd.conf"
done
