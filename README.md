# zabbix_monitor_flume_es
monitor flume/kafka/elasticsearch by zabbix

<h3> script description</h3>
<table>
    <tr>
        <td>功能</td>
        <td>名称</td>
        <td>类型</td>
        <td>作用</td>
        <td>传递参数</td>
        <td>说明</td>
    </tr>
    <tr>
        <td rowspan="11">脚本</td>
        <td>apm_process_discovery.py</td>
        <td>自动发现脚本</td>
        <td>获取进程名称，最终传递给监控脚本，用于监控young gc、collector物理内存cpu使用情况需要的进程名参数。</td>
        <td>无</td>
        <td>collecot、gc监控脚本使用</td>
    </tr>
    <tr>
        <td>apm_property_get_discovery.py</td>
        <td>自动发现脚本</td>
        <td>获取flume(端口、对象、属性)、kafka（topic、端口）、ES(node)等参数。</td>
        <td>无</td>
        <td>获取flume\kafka\es等监控脚本的参数</td>
    </tr>
    <tr>
        <td>system_diskio_discovery.pl</td>
        <td>自动发现脚本</td>
        <td>获取操作系统所有disk分区。</td>
        <td>无</td>
        <td>用于监控磁盘io</td>
    </tr>
    <tr>
        <td>apm_process_monitor.sh</td>
        <td>监控脚本</td>
        <td>监控collector进程使用内存、cpu的值。</td>
        <td>[进程名称,cpu|mem]</td>
        <td>接收两个参数，第一个为进程名，，第二个为cpu或mem,参数来自APM_PRO.conf</td>
    </tr>
    <tr>
        <td>disk_iostat_monitor.sh</td>
        <td>监控脚本</td>
        <td>监控磁盘io</td>
        <td>[diskname]</td>
        <td>一个参数，磁盘名称.sda/sdb/fio等</td>
    </tr>
    <tr>
        <td>es_monitor.py</td>
        <td>监控脚本</td>
        <td>监控es相关指标</td>
        <td>[node|cluster,对象名]</td>
        <td>接收两个参数，参数来至flume_zabbix.conf</td>
    </tr>
    <tr>
        <td>flume_monitor.sh</td>
        <td>监控脚本</td>
        <td>监控flume相关指标</td>
        <td>[对象的属性，对象，端口]</td>
        <td>接收三个参数，参数来自flume_zabbix.conf</td>
    </tr>
    <tr>
        <td>java_yggc_monitor.sh</td>
        <td>监控脚本</td>
        <td>监控java young gc次数</td>
        <td>[进程名称]</td>
        <td>接收一个参数，参数来自APM_PRO.conf文件</td>
    </tr>
    <tr>
        <td>linux_openfiles_monitor.sh</td>
        <td>监控脚本</td>
        <td>监控系统文件打开数</td>
        <td>无</td>
        <td></td>
    </tr>
    <tr>
        <td>zookeeper_monitor.sh</td>
        <td>监控脚本</td>
        <td>监控zookeeper相关指标</td>
        <td> [指标名，端口]</td>
        <td></td>
    </tr>
    <tr>
        <td>syslog_send_ump.py</td>
        <td>告警推送脚本</td>
        <td>用于发送告警至syslong探针</td>
        <td> [sendto,subject,msg]</td>
        <td>只推送msg到syslog探针，msg在zabbix web界面配置。</td>
    </tr>
    <tr>
        <td rowspan="3">配置文件</td>
        <td>APM_PRO.conf</td>
        <td>自动发现脚本配置文件</td>
        <td>用于填写进程名称</td>
        <td>无</td>
        <td>包括监控gc和collector的进程名</td>
    </tr>
    <tr>
        <td>flume_zabbix.conf</td>
        <td>自动发现脚本配置文件</td>
        <td>设置监控flume、es、kafka的相关参数。</td>
        <td>无</td>
        <td>包括端口，对象，属性等参数。</td>
    </tr>
    <tr>
        <td>zabbix_apm.conf</td>
        <td>自定义key配置文件</td>
        <td>zabbix agent include配置文件,将监控脚本映射为KEY,用于建立items时使用</td>
        <td>无</td>
        <td>agent 额外配置文件</td>
    </tr>
</table>

<h3>monitor indicator</h3>
<table>
    <tr>
        <td>监控分类</td>
        <td>监控参数</td>
        <td>名称</td>
    </tr>
    <tr>
        <td rowspan="9">系统性能</td>
        <td>Processor load (1 min average per core)</td>
        <td>cpu 1、5、15分钟负载</td>
    </tr>
    <tr>
        <td>CPU idle time</td>
        <td>cpu空闲率</td>
    </tr>
    <tr>
        <td>Available memory</td>
        <td>可用内存</td>
    </tr>
    <tr>
        <td>Free swap space in %</td>
        <td>swap空闲率</td>
    </tr>
    <tr>
        <td>Number of processes</td>
        <td>系统打开进程数</td>
    </tr>
    <tr>
        <td>Free disk space on /</td>
        <td>文件系统使用率</td>
    </tr>
    <tr>
        <td>Outgoing network traffic on virbr0（出）</td>
        <td>网卡出/入流量</td>
    </tr>
    <tr>
        <td>IO_Stats util on sda</td>
        <td>磁盘负载率</td>
    </tr>
    <tr>
        <td>current openfile</td>
        <td>系统打开文件数</td>
    </tr>
    <tr>
        <td rowspan="9">Flume</td>
        <td>flume source rate for SOURCE.ttmSrc0</td>
        <td>source每分钟处理数据</td>
    </tr>
    <tr>
        <td>Flume {sourcename} of the EventReceivedCount port:端口</td>
        <td>source接收总数据量</td>
    </tr>
    <tr>
        <td>Flume {ChannelName} of the ChannelFillPercentage port:端口</td>
        <td>channel通道占比</td>
    </tr>
    <tr>
        <td>flume channel rate for CHANNEL.memoryChannel</td>
        <td>channel每分钟递交sink数据量</td>
    </tr>
    <tr>
        <td>Flume {ChannelName} of the EventTakeSuccessCount port:端口</td>
        <td>channel递交sink总数据量</td>
    </tr>
    <tr>
        <td>flume sink rate for SINK.avroSink1</td>
        <td>sink每分钟处理数据量</td>
    </tr>
    <tr>
        <td>Flume {SinkName} of the EventDrainSuccessCount port:端口</td>
        <td>sink处理总的数据量</td>
    </tr>
    <tr>
        <td>heap</td>
        <td>flume head 内存大小监控</td>
    </tr>
    <tr>
        <td>gc</td>
        <td>flume young gc状态</td>
    </tr>
    <tr>
        <td rowspan="5">collector</td>
        <td>inux.process.used.status</td>
        <td>collector使用内存大小</td>
    </tr>
    <tr>
        <td>inux.process.used.status</td>
        <td>collector使用cpu大小</td>
    </tr>
    <tr>
        <td>collector {ChannelName} of the ChannelFillPercentage port:端口</td>
        <td>collector 通道占比</td>
    </tr>
    <tr>
        <td>heap</td>
        <td>collector heap大小</td>
    </tr>
    <tr>
        <td>gc</td>
        <td>collector gc状态</td>
    </tr>
    <tr>
        <td rowspan="6">kafka</td>
        <td>kafka {TopicName} lag status</td>
        <td>topic的未消费消息堆积量</td>
    </tr>
    <tr>
        <td>kafka-broker-message-in-count</td>
        <td>所有的topic的消费信息</td>
    </tr>
    <tr>
        <td>kafka-producer-request-count</td>
        <td>producer请求数量</td>
    </tr>
    <tr>
        <td>kafka-consumer-fetchreqests-count</td>
        <td>consumer获取请求数量</td>
    </tr>
    <tr>
        <td>heap</td>
        <td>flume head 内存大小监控</td>
    </tr>
    <tr>
        <td>gc</td>
        <td>flume young gc状态</td>
    </tr>
    <tr>
        <td rowspan="6">zookeeper</td>
        <td>zk_avg_latency</td>
        <td>响应客户端请求的时间</td>
    </tr>
    <tr>
        <td>zk_outstanding_requests</td>
        <td>排队请求的数量</td>
    </tr>
    <tr>
        <td>zk_packets_received</td>
        <td>接收到客户端请求的包数量</td>
    </tr>
    <tr>
        <td>zk_packets_sent</td>
        <td>响应和通知客户端的包数量</td>
    </tr>
    <tr>
        <td>gc</td>
        <td>young gc监控</td>
    </tr>
    <tr>
        <td>heap</td>
        <td>heap监控</td>
    </tr>
    <tr>
        <td rowspan="6">elasticsearch</td>
        <td>ES-cluster-indexing_total</td>
        <td>ES索引记录总数</td>
    </tr>
    <tr>
        <td>ES-cluster-docs-count</td>
        <td>ES文档数</td>
    </tr>
    <tr>
        <td>ES-cluster-stats</td>
        <td>ES集群节点状态</td>
    </tr>
    <tr>
        <td>ES-node-heap-memory</td>
        <td>es heap 内存大小监控</td>
    </tr>
    <tr>
        <td>ES-node-young-gc-count</td>
        <td>es young gc次数</td>
    </tr>
    <tr>
        <td>ES-node-old-gc-count</td>
        <td>es old gc次数</td>
    </tr>
</table>
