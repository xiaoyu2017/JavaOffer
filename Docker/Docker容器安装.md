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

