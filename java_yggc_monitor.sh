#/bin/bash




name=$1
PID=`ps -ef|grep  $name |grep -v grep|grep -v zabbix|awk '{print $2}'`
CMD=`ps -ef|grep  $name |grep -v grep|grep -v zabbix|awk '{print $8}'`

comm=${CMD%/*}
#echo $PID 11111
if [ ${#comm} -gt 4 ];then
#	$comm/jstat -gcutil $PID|awk '{print $6}'|grep [0-9]
	sudo $comm/jstat -gcutil $PID|awk '{for(i=1;i<=NF;i++) if($i=="YGC") c=i}{print $c}'|grep [0-9]
else
#	echo 111
#	jstat -gcutil 33796
#	sudo	jstat -gcutil $PID|awk '{print $6}'|grep [0-9]
	sudo jstat -gcutil $PID|awk '{for(i=1;i<=NF;i++) if($i=="YGC") c=i}{print $c}'|grep [0-9]
fi
