#!/bin/bash


#


if [ $# == 3 ];then
	KEY=`curl http://127.0.0.1:$3/metrics 2>/dev/null |sed -e's/},/\n/g' |grep -w $2 |sed -e's/[,]\s*/\n/g' -e's/[{}]/\n/g' -e 's/[",]//g' |grep -w $1 |awk -F ':' '{print $2}'`
	if [ "$KEY" == "" ];then
		KEY=-1
	fi
	echo $KEY
elif [ $# == 2 ];then
       curl http://127.0.0.1:$2/metrics 2>/dev/null|sed -e's/},/\n/g' |sed -e's/[,]\s*/\n/g' -e's/[{}]/\n/g' -e 's/[",]//g' |grep $1 |head -1 |awk -F ':' '{print $2}' 
else
	echo "input error"
fi
