# 1. Mysql

下载镜像：`docker pull mysql:latest` 或 `docker pull mysql:8.0`

创建容器：

```shell
docker run \
--name mysql8 \
--privileged=true \
-e MYSQL_ROOT_PASSWORD=root \
-p 12400:3306 \
-d mysql:8.0
```

进入容器：`docker exec -it mysql8 bash`

进入mysql：`mysql -uroot -proot`

修改密码设置所有主机可见：`ALTER USER 'root'@'%' IDENTIFIED WITH mysql_native_password BY '新密码'`

刷新权限：`flush privileges`

# 2. ElasticSearch

下载镜像：`docker pull elasticsearch:latest` 或 `docker pull elasticsearch:7.17.7`

创建容器：

```shell
docker run -d \
	--name es \
    -e "ES_JAVA_OPTS=-Xms512m -Xmx512m" \
    -e "discovery.type=single-node" \
    -v es-data:/usr/share/elasticsearch/data \
    -v es-plugins:/usr/share/elasticsearch/plugins \
    --privileged \
    -p 12401:9200 \
    -p 12402:9300 \
elasticsearch:7.17.7
```

测试是否成功：`curl localhost:9200`

## 2.1 安装分词插件

查看数据卷挂载位置：`docker inspect es-plugins`

```json
[
  {
    "CreatedAt": "2023-02-09T17:31:17+08:00",
    "Driver": "local",
    "Labels": null,
    "Mountpoint": "/var/lib/docker/volumes/es-plugins/_data",
    "Name": "es-plugins",
    "Options": null,
    "Scope": "local"
  }
]
```

上传插件到`/var/lib/docker/volumes/es-plugins/_data`位置。

重启es：`docker restart es`

## 2.2 修改远程访问

进入docker的es容器：`docker exec -it es /bin/bash`

修改配置文件：`vi /data/elasticsearch/config/elasticsearch.yml    `

```yaml
cluster.name: "docker-cluster-01"
network.host: 0.0.0.0
http.cors.enabled: true
http.cors.allow-origin: "*"
# 此处开启xpack
xpack.security.enabled: true
```

进入es目录的bin目录执行修改密码：`./elasticsearch-setup-passwords interactive`

逐条进行密码设置即可。

重启es：`docker restart es`

# 3. Redis

下载镜像：`docker pull redis:latest` 或 `docker pull redis:7.0`

创建容器：

```shell
docker run \
--name redis7 \
-v redis7-conf:/usr/local/etc/redis \
-v redis7-data:/data \
-p 12403:6379 \
-d redis:7.0 \
redis-server /usr/local/etc/redis/redis.conf
```

查看数据卷位置：`docker inspect redis7-conf`

```json
[
  {
    "CreatedAt": "2023-02-09T23:49:11+08:00",
    "Driver": "local",
    "Labels": null,
    "Mountpoint": "/var/lib/docker/volumes/redis7-conf/_data",
    "Name": "redis7-conf",
    "Options": null,
    "Scope": "local"
  }
]
```

上传配置文件到`/var/lib/docker/volumes/redis7-conf/_data`

**注意：配置文件中`daemonize no`配置不能改成`yes`，这和docker的`-d`参数冲突会导致redis启动不了**

# 4. RocketMQ

下载镜像：`docker pull apache/rocketmq:4.5.1`

创建网络：`docker network create rocketmq`

创建namesrv容器：

```shell
docker run -d \
--name rocketmq-namesrv \
--network rocketmq \
-p 9876:9876 \
-v /Users/yujiangzhong/DockerData/rocketmq/namesrv/logs:/root/logs \
-v /Users/yujiangzhong/DockerData/rocketmq/namesrv/store:/root/store \
-e "MAX_POSSIBLE_HEAP=1024" \
apache/rocketmq:4.5.1 \
sh mqnamesrv
```

说明：
`-e "MAX_POSSIBLE_HEAP=1024"`：设置容器的最大堆内存。

创建配置文件：broker.conf

```conf
# 所属集群名称，如果节点较多可以配置多个
brokerClusterName = DefaultCluster
#broker名称，master和slave使用相同的名称，表明他们的主从关系
brokerName = broker-a
#0表示Master，大于0表示不同的slave
brokerId = 0
#表示几点做消息删除动作，默认是凌晨4点
deleteWhen = 04
#在磁盘上保留消息的时长，单位是小时
fileReservedTime = 48
#有三个值：SYNC_MASTER，ASYNC_MASTER，SLAVE；同步和异步表示Master和Slave之间同步数据的机制；
brokerRole = SYNC_MASTER
#刷盘策略，取值为：ASYNC_FLUSH，SYNC_FLUSH表示同步刷盘和异步刷盘；SYNC_FLUSH消息写入磁盘后才返回成功状态，ASYNC_FLUSH不需要；
flushDiskType = SYNC_FLUSH
# 设置broker节点所在服务器的ip地址（**这个非常重要,主从模式下，从节点会根据主节点的brokerIP2来同步数据，如果不配置，主从无法同步，brokerIP1设置为自己外网能访问的ip，服务器双网卡情况下必须配置，比如阿里云这种，主节点需要配置ip1和ip2，从节点只需要配置ip1即可）
brokerIP1 = 127.0.0.1
#nameServer地址，分号分割
namesrvAddr=127.0.0.1:9876
#Broker 对外服务的监听端口,
listenPort = 10911
#是否允许Broker自动创建Topic
autoCreateTopicEnable = true
#是否允许 Broker 自动创建订阅组
autoCreateSubscriptionGroup = true
#linux开启epoll
useEpollNativeSelector = true

#数据存放的根目录
#storePathRootDir = /root/store/path
#commit log保存目录
#storePathCommitLog = /root/store/path/commitlog
#消费队列存储路径存储路径
#storePathConsumerQueue = /root/store/path/consumequeue

slaveReadEnable = true
```

日志文件：
[logback_broker.xml](./files/logback_broker.xml)
[logback_namesrv.xml](./files/logback_namesrv.xml)
[logback_tools.xml](./files/logback_tools.xml)

创建broker容器:

```shell
docker run -d \
--name rocketmq-broker-a \
--network rocketmq \
-p 10909:10909 \
-p 10911:10911 \
-v /Users/yujiangzhong/DockerData/rocketmq/borker/logs:/root/logs \
-v /Users/yujiangzhong/DockerData/rocketmq/borker/store:/root/store \
-v /Users/yujiangzhong/DockerData/rocketmq/borker/conf:/home/rocketmq/rocketmq-4.5.1/conf \
-e "JAVA_OPT_EXT=-server -Xms1g -Xmx1g -Xmn512m" apache/rocketmq:4.5.1 sh mqbroker \
-c /home/rocketmq/rocketmq-4.5.1/conf/broker.conf
```

创建控制台：

```shell
docker run -d \
--name rocketmq-console \
--network rocketmq \
-e "JAVA_OPTS=-Drocketmq.namesrv.addr=rocketmq-namesrv:9876 \
-Dcom.rocketmq.sendMessageWithVIPChannel=false" \
-p 8000:8080 apacherocketmq/rocketmq-dashboard:latest
```

# 5. CentOS7(固定IP)

查看容器ip：`hostname -i`

创建指定ip段网络：`docker network create --subnet=172.12.4.0/16 CentosNetwork`

创建centos7并指定ip：

```shell
docker run -itd \
--name centos-master \
--net CentosNetwork \
--ip 172.12.4.0 centos:centos7
```

```shell
docker run -itd \
--name centos-slave1 \
--net CentosNetwork \
--ip 172.12.4.1 centos:centos7
```

```shell
docker run -itd \
--name centos-slave2 \
--net CentosNetwork \
--ip 172.12.4.2 centos:centos7
```

```shell
docker run -itd \
--name centos-slave3 \
--net CentosNetwork \
--ip 172.12.4.3 centos:centos7
```

# 6. Redis主从集群

下载镜像：`docker pull redis:latest` 或 `docker pull redis:7.0`

创建网络：`docker network create --subnet=172.13.4.0/16 RedisMSNetwork`

创建容器：

```shell
docker run \
--name redis7MS0 \
--net RedisMSNetwork \
--ip 172.13.4.0 \
-v /Users/yujiangzhong/DockerData/redis/RedisMasterSlave/redis0/conf:/usr/local/etc/redis \
-v /Users/yujiangzhong/DockerData/redis/RedisMasterSlave/redis0/data:/data \
-p 13400:6379 \
-d redis:7.0 \
redis-server /usr/local/etc/redis/redis.conf

docker run \
--name redis7MS1 \
--net RedisMSNetwork \
--ip 172.13.4.1 \
-v /Users/yujiangzhong/DockerData/redis/RedisMasterSlave/redis1/conf:/usr/local/etc/redis \
-v /Users/yujiangzhong/DockerData/redis/RedisMasterSlave/redis1/data:/data \
-p 13401:6379 \
-d redis:7.0 \
redis-server /usr/local/etc/redis/redis.conf

docker run \
--name redis7MS2 \
--net RedisMSNetwork \
--ip 172.13.4.2 \
-v /Users/yujiangzhong/DockerData/redis/RedisMasterSlave/redis2/conf:/usr/local/etc/redis \
-v /Users/yujiangzhong/DockerData/redis/RedisMasterSlave/redis2/data:/data \
-p 13402:6379 \
-d redis:7.0 \
redis-server /usr/local/etc/redis/redis.conf
```





