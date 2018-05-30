#!/bin/sh
#运维工具



sphelp(){
cat <<EOF
  
   -h  --help   
    检查文件打开数量
    运行方法: ./$0 
	
    退出码
   被调用插件程序的退出码必须为：0、1、2、3
   含义：
   0 正常
   1警告
   2错误
   3未知
   
EOF
exit 3
}


#定义处理函数
perf_usage(){

opened_files=`sudo lsof |wc -l`
max_files=`ulimit -n`
((useage=${opened_files}*100/${max_files}))

echo $useage
#if [ $useage -gt 70 ] ;then
#   echo "文件打开数过多 ${useage}%"
#   exit 2
#else
#    echo "文件打开数正常 ${useage}%"
#   exit 0		
#fi
  
}

### 开始执行脚本
# 判断输入参数是否为help/h
#if [ $1 = "--help" -o $1 = "-h" ];then
#   sphelp
#fi


perf_usage


