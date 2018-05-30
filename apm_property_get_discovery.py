#!/bin/env python
#-*-coding=utf-8-*-

#
import re,json
import os,sys
'''OBJECT属性的带端口参数，调用filter ，再调用value_list_port,最后调用result_json。'''
'''返回字典，接受三个参数调用此方法i（带有端口），返还格式{port:{object:{[key,key]}}}'''
def filter(file):


	pattern = re.compile(r'^\d+$')
	file_list = file
	file_str = ''.join(file_list)
	port_list = file_str.split('PORT=')
	port_list.remove('')

	for i in port_list:
		object_list = re.split(r'\n+',i)
		object_list.remove('')
		value_port = pattern.match(object_list[0])
		if value_port != None:
			port = value_port.group()
			OBJECT = filter_argv(object_list,1,port)
		filter_data[value_port.group()] = OBJECT
#	print(filter_data)
	return filter_data

'''#接受一个列表，无端口，结果格式{object:[key,key]},'''
def object_dict(object_list):
	OBJECT = {}
	pattern1 = re.compile(r'^OBJECT\=(.*)')
	for v in range(len(object_list)):
		object_value = pattern1.match(object_list[v])
		if object_value != None:
			value_list = object_value.group(1).split(",")
			object_key = value_list.pop(0)
			OBJECT[object_key] = value_list
	return  OBJECT	
'''#接受列表，返还列字典列表[{key:value,key1:value1},{key:value}],方法用于处理参数1跟参数2没有继承关系。OBJECT1 OBJECT2格式带端口调用filter 后调用result_json,无端口直接调用filter_argv'''
def filter_argv(file,num,port):
	
#	Result_list = []
	object_file = []
	list2 = []
	obj_list2 = None
	pattern = re.compile(r'^OBJECT1\=(.*)')
	pattern2 = re.compile(r'^OBJECT2\=(.*)')
	PORT = port
	for v in range(num,len(file)):
		object_value = pattern.match(file[v])
		if object_value == None:
			object_value2 = pattern2.match(file[v])
			if object_value2 == None:
				object_file.append(file[v])
			else:
				obj_list2 = object_value2.group(1)
		else:
			obj_list1 = object_value.group(1)
	if object_file:
		OBJECT = object_dict(object_file)
		return OBJECT
	if obj_list2:
		list2 = obj_list2.split(",")
	list1 = obj_list1.split(",")
	if len(list1) == len(list2):
		for i in range(len(list1)):
			R_Dict = {}
			if PORT:
				R_Dict["{#PORT}"] = PORT
			R_Dict["{#KAFKA}"] = list1[i]
			R_Dict["{#KAFKA2}"] = list2[i]
			Result_list.append(R_Dict)
	else:
		for i in range(len(list1)):
			R_Dict = {}
			if PORT:
				R_Dict["{#PORT}"] = PORT
#only OBJECT1,for ES,see   flume_zabbix.conf,>ES
			R_Dict["{#ESNODE}"] = list1[i]
			Result_list.append(R_Dict)
	return Result_list

'''不带端口OBJECT格式'''
def value_list(data):
	filter_data = data
	for key in filter_data:
		Temp_list = filter_data[key]
		for p in range(len(Temp_list)):
			R_Dict = {}
			R_Dict["{#KAFKA}"] = object_name
			R_Dict["{#KAFKA2}"] = Temp_list[p]
					
			Result_list.append(R_Dict)
		
	return Result_list
'''带端口OBJECT格式'''
def value_list_port(data):

	filter_data = data
	for port in filter_data:
		for object_name in filter_data[port]:
			Temp_list = filter_data[port][object_name]
			for p in range(len(Temp_list)):
				R_Dict = {}
				R_Dict["{#PORT}"] = port
				R_Dict["{#OBJECTNAME}"] = object_name
				R_Dict["{#OBJECTVALUE}"] = Temp_list[p]
					
				Result_list.append(R_Dict)
#	print(Result_list)
	return Result_list

	

def get_port():

	PS = os.popen('ps -elf|grep -w flume|grep -v grep|grep -v collector').readlines()
	pattern = re.compile(r'(-Dflume\.monitoring\.port)\=(\d+)')
	R_LIST = []
	PORT = []

	for i in PS:
        	Temp_List = list(i.split(" "))
        	try:
                	T_PORT = pattern.search(i).group(2)
        	except IndexError:
                	exit()
        	PORT.append(T_PORT)
	
	return PORT

def return_json(Result_list):

#	Result_list = value_list(data)
	print(json.dumps({"data":Result_list},sort_keys=True,indent=4))


if __name__ == '__main__':

	flume_data = []
	kafka_data = []
	Result_list = []	
	filter_data = {}

	
	
	fenge = re.compile(r'\>(.*)\:$')
	space = re.compile(r'^$|^\n$|^ +\n$')
	note = re.compile(r'^#')
	try:
		f = open("/opt/APM/zabbix/alertscripts/conf/flume_zabbix.conf",'r')
		T_list = []
		for i in f.readlines():
			if space.match(i) != None or note.match(i) != None:
				continue
			if fenge.search(i) == None:
				T_list.append(i)
			else:
				flag = fenge.search(i).group(1)
				if flag == "FLUME":
					flume_data = T_list
				elif flag == "KAFKA" or flag == "ES":
					kafka_data = T_list
				T_list = []	
		f.close()
	except IOError:
		print("configure file not found")
		exit()

	if flume_data:
		file = flume_data
		data = filter(file)
		value_list_port(data)
	if kafka_data:
		file = kafka_data
		filter_argv(file,0,None)
	return_json(Result_list)
