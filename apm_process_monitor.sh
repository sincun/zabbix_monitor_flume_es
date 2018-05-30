#!/bin/bash

#
PRO_NAME=$1
Resources=$2
SCRIPT_NAME=`basename $0`

PRO_PID_LINE=`ps -elf|grep -w $PRO_NAME|grep -v grep|grep -v  $SCRIPT_NAME|grep -v 'linux.process.used.status'|awk '{print $4}'`


#define PID array
c=0
for i in $PRO_PID_LINE
do
	PRO_PID[$c]=$i
	let c++
done

if [ ${#PRO_PID[*]} -ne 1 ];then
	echo "input process name error"
	exit 1
fi

PID=${PRO_PID[0]}
EXEC_COUNT=`ps -elf|grep $SCRIPT_NAME|grep -v 'linux.process.used.status'|grep -v grep|wc -l`

if [ $EXEC_COUNT -le 10 ];then
	if [ $Resources == "mem" -o $Resources == "MEM" -o $Resources == "Mem" ];then
		T_Result=$(top -bn1|tail -n +7|awk '$1==SPID{print $6}' SPID=$PID)
		end=`echo ${T_Result:0-1:1}`
		#
		if [ "$end" == "g" ];then
			T_KEY=`echo ${T_Result%g*}`
			KEY=`awk -v t_key=$T_KEY 'BEGIN{printf "%.2f\n",(t_key*1024*1024*1024)}'`
		elif [ "$end" == "m" ];then
			T_KEY=`echo ${T_Result%m*}`
			KEY=`awk -v t_key=$T_KEY 'BEGIN{printf "%.2f\n",(t_key*1024*1024*1024)}'`
		elif [ -n "`echo $T_Result|sed -n '/^[0-9]*$/p'`" ];then
			KEY=`awk -v t_key=$T_Result 'BEGIN{printf "%.2f\n",(t_key*1024)}'`
		fi
		echo ${KEY}
	elif [ $Resources == "cpu" -o $Resources == "CPU" -o $Resources == "Cpu" ];then
		CORE=`cat /proc/cpuinfo|grep -w "processor"|wc -l`
		KEY=`top -bn1|tail -n +7|awk -v SPID=$PID '$1==SPID{print $9}'`
		echo $KEY
	fi
else
        echo -1
        echo "EXEC_COUNT too much:`ps -elf|grep $SCRIPT_NAME|grep -v 'linux.process.used.status'|grep -v grep`">> /opt/APM/zabbix/alertscripts/exec_count_test.txt
fi


