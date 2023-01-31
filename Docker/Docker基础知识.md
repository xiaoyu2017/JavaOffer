# 1. Docker概述

> Docker是一个开源应用容器引擎，它可以将应用和依赖一起打包到可移植容器中，然后发布到任何linux或windows系统上运行，

## 1.1 如何解决不同应用依赖兼容问题

> Docker将应用、依赖、函数库和配置一起打包，形成可运行镜像。Docker应用运行在容器中，采用沙箱机制，相互隔离就不存在依赖兼容问题。

![](https://github.com/xiaoyu2017/JavaOffer/blob/master/img/docker0.png?raw=true)

## 1.2 Docker和虚拟机区别

- Docker是系统的一个进程，模仿系统运行的环境，环境之间是相互隔离的。虚拟机模仿设备硬件，然后在模拟硬件上运行其他操作系统。
- docker体积小，运行快，性能好。虚拟机体积大，运行慢，性能一般。

![](https://github.com/xiaoyu2017/JavaOffer/blob/master/img/docker1.png?raw=true)

## 1.3 镜像和容器

镜像：应用及依赖打成的包称为镜像。

容器：通过镜像创建的运行程序被称为容器，一个镜像可以创建多个容器，之间相互隔离。

镜像分为两部分：`repository:tag`，在没有指定版本情况下默认是latest。

![](https://github.com/xiaoyu2017/JavaOffer/blob/master/img/docker2.png?raw=true)

# 2. 基本操作

![](https://github.com/xiaoyu2017/JavaOffer/blob/master/img/docker4.png?raw=true)

## 2.1 pull

> 从远程仓库拉取镜像。

`docker pull [镜像名称][:镜像版本]`

示例：`docker pull mysql:8.0`

## 2.2 images

> 查看所有镜像

`docker images`

## 2.3 save、load

> 将镜像导出到本地，或者从本地导入镜像。

`docker save -o [保存的目标文件名称] [镜像名称]`

示例：`docker save -o nginx.tar nginx:latest`

加载示例：`docker load -i nginx.tar`

## 2.4 rmi

> 删除镜像

删除nginx镜像：`docker rmi nginx:latest`

# 3. 容器操作

![](https://github.com/xiaoyu2017/JavaOffer/blob/master/img/docker5.png?raw=true)

## 3.1 run

> 创建并运行一个容器，处于运行状态。

`docker run --name containerName -p 80:80 -d nginx`

- docker run ：创建并运行一个容器
- --name : 给容器起一个名字，比如叫做mn
- -p ：将宿主机端口与容器端口映射，冒号左侧是宿主机端口，右侧是容器端口
- -d：后台运行容器
- nginx：镜像名称，例如nginx

## 3.2 exec

> 进入容器进行操作，例如修改配置文件等。

`docker exec -it mn bash`

- docker exec ：进入容器内部，执行一个命令
- -it : 给当前进入的容器创建一个标准输入、输出终端，允许我们与容器交互
- mn ：要进入的容器的名称
- bash：进入容器后执行的命令，bash是一个linux终端交互命令

## 3.3 pause、unpause

> pause：让一个运行的容器暂停, unpause：让一个容器从暂停状态恢复运行。

暂停：`docker pause 容器名称`

暂停恢复：`docker unpause 容器名称`

## 3.4 stop、start、restart

stop:`docker stop 容器名称`，停止一个容器。

start:`docker start 容器名称`，开始运行一个容器。

restart:`docker restart 容器名称`，重启一个容器。

## 3.5 rm

> 删除一个容器。

`docker rm [选项] [容器0，容器1...]`

强制删除：`docker rm -f [容器0，容器1...]`

删除连接网络：`docker rm -l [网络连接名]`

删除容器，并删除容器挂载的数据卷：`docker rm -v [容器0，容器1...]`

# 4. 数据卷操作

> **数据卷（volume）**是一个虚拟目录，指向宿主机文件系统中的某个目录。不同系统可能存在差异（宿主系统）。

![](https://github.com/xiaoyu2017/JavaOffer/blob/master/img/docker3.png?raw=true)

## 4.1 操作命令

语法：`docker volume [COMMAND]`

- create 创建一个volume
- inspect 显示一个或多个volume的信息
- ls 列出所有的volume
- prune 删除未使用的volume
- rm 删除一个或多个指定的volume

## 4.2 挂载数据卷

```shell
docker run \
--name mn \
-v html:/usr/share/nginx/html \
-p 80:80 \
-d nginx
```

`-v html:/root/htm` ：把html数据卷挂载到容器内的/root/html这个目录中

# 5. Dockerfile自定义镜像

> 我们只需要告诉Docker，我们的镜像的组成，需要哪些BaseImage、需要拷贝什么文件、需要安装什么依赖、启动脚本是什么，将来Docker会帮助我们构建镜像

![](https://github.com/xiaoyu2017/JavaOffer/blob/master/img/docker7.png?raw=true)

示例：
![](https://github.com/xiaoyu2017/JavaOffer/blob/master/img/docker6.png?raw=true)

> **Dockerfile**就是一个文本文件，其中包含一个个的**指令(Instruction)**，用指令来说明要执行什么操作来构建镜像。每一个指令都会形成一层Layer。

```shell
# 指定基础镜像
FROM ubuntu:16.04
# 配置环境变量，JDK的安装目录
ENV JAVA_DIR=/usr/local

# 拷贝jdk和java项目的包
COPY ./jdk8.tar.gz $JAVA_DIR/
COPY ./docker-demo.jar /tmp/app.jar

# 安装JDK
RUN cd $JAVA_DIR \
 && tar -xf ./jdk8.tar.gz \
 && mv ./jdk1.8.0_144 ./java8

# 配置环境变量
ENV JAVA_HOME=$JAVA_DIR/java8
ENV PATH=$PATH:$JAVA_HOME/bin

# 暴露端口
EXPOSE 8090
# 入口，java项目的启动命令
ENTRYPOINT java -jar /tmp/app.jar
```

执行构建命令即可：`docker build -t javaweb:1.0 .`


> 以上是比较麻烦的，也可以基于已经有的jdk环境进行配置，就比较简单。

```shell
FROM java:8-alpine
COPY ./app.jar /tmp/app.jar
EXPOSE 8090
ENTRYPOINT java -jar /tmp/app.jar
```

# 6. Docker-Compose

> Docker Compose就是一个文本文件，而无需手动一个个创建和运行容器！Compose就是一个文本文件。

语法参考官网：[官网](https://docs.docker.com/compose/compose-file/)

创建Compose文件：

```yaml
version: "3.2"

services:
  nacos:
    image: nacos/nacos-server
    environment:
      MODE: standalone
    ports:
      - "8848:8848"
  mysql:
    image: mysql:5.7.25
    environment:
      MYSQL_ROOT_PASSWORD: 123
    volumes:
      - "$PWD/mysql/data:/var/lib/mysql"
      - "$PWD/mysql/conf:/etc/mysql/conf.d/"
  mallUser:
    build: ./mall-user
  mallOrder:
    build: ./mall-user
  mallGateway:
    build: ./mall-gateway
    ports:
      - "10010:10010"
```

- `nacos`：作为注册中心和配置中心
    - `image: nacos/nacos-server`： 基于nacos/nacos-server镜像构建
    - `environment`：环境变量
        - `MODE: standalone`：单点模式启动
    - `ports`：端口映射，这里暴露了8848端口
- `mysql`：数据库
    - `image: mysql:5.7.25`：镜像版本是mysql:5.7.25
    - `environment`：环境变量
        - `MYSQL_ROOT_PASSWORD: 123`：设置数据库root账户的密码为123
    - `volumes`：数据卷挂载，这里挂载了mysql的data、conf目录，其中有我提前准备好的数据
- `mall-user`、`mall-order`、`mall-gateway`：都是基于Dockerfile临时构建的

新建文件目录：

![](https://github.com/xiaoyu2017/JavaOffer/blob/master/img/docker8.png?raw=true)

> mysql目录是用于挂载目录。

三个服务项目目录下的Dockerfile配置：

```text
FROM java:8-alpine
COPY ./app.jar /tmp/app.jar
ENTRYPOINT java -jar /tmp/app.jar
```

修改服务配置文件，微服务容器之间访问使用的是容器名称访问：

```yaml
spring:
  datasource:
    url: jdbc:mysql://mysql:33060/mall?useSSL=false
    username: root
    password: root
    driver-class-name: com.mysql.jdbc.Driver
  application:
    name: mall-user
  cloud:dock
  nacos:
    server-addr: nacos:8848 # nacos服务地址
```

使用maven打包服务：

```xml

<build>
    <!-- 服务打包的最终名称 -->
    <finalName>app</finalName>
    <plugins>
        <plugin>
            <groupId>org.springframework.boot</groupId>
            <artifactId>spring-boot-maven-plugin</artifactId>
        </plugin>
    </plugins>
</build>
```

在当前目录执行构建命令：`docker-compose up -d`

# 8. 安装Docker

## 8.1 Centos7安装

卸载老版本：

```shell
yum remove docker \
  docker-client \
  docker-client-latest \
  docker-common \
  docker-latest \
  docker-latest-logrotate \
  docker-logrotate \
  docker-selinux \
  docker-engine-selinux \
  docker-engine \
  docker-ce
```

安装yum：系统需要联网

```shell
yum install -y yum-utils \
           device-mapper-persistent-data \
           lvm2 --skip-broken
```

设置镜像源：

```shell
# 设置docker镜像源
yum-config-manager \
    --add-repo \
    https://mirrors.aliyun.com/docker-ce/linux/centos/docker-ce.repo
    
sed -i 's/download.docker.com/mirrors.aliyun.com\/docker-ce/g' /etc/yum.repos.d/docker-ce.repo

yum makecache fast
```

安装docker-ce：社区免费版

```shell
yum install -y docker-ce
```

docker需要使用各种端口，所以建议使用时关闭防火墙：

```shell
# 关闭
systemctl stop firewalld
# 禁止开机启动防火墙
systemctl disable firewalld
```

docker的操作命令：

```shell
systemctl start docker  # 启动docker服务

systemctl stop docker  # 停止docker服务

systemctl restart docker  # 重启docker服务
```

配置阿里镜像：[阿里镜像配置](https://cr.console.aliyun.com/cn-hangzhou/instances/mirrors?accounttraceid=cb36295bddcd4367b89d118e2471c930hdty)

## 8.2 Centos7安装DockerCompose

下载安装包：

```shell
# 安装
curl -L https://github.com/docker/compose/releases/download/1.23.1/docker-compose-`uname -s`-`uname -m` > /usr/local/bin/docker-compose
```

```shell
# 修改权限
chmod +x /usr/local/bin/docker-compose
```

```shell
# 补全命令
curl -L https://raw.githubusercontent.com/docker/compose/1.29.1/contrib/completion/bash/docker-compose > /etc/bash_completion.d/docker-compose
```

如果有错误：`echo "199.232.68.133 raw.githubusercontent.com" >> /etc/hosts`

# 7. 搭建Docker镜像私库

## 7.1 简化版私有仓库

> 由Docker官网提供的简易仓库管理镜像，功能完善，但是不具备操作化界面。

```shell
docker run -d \
    --restart=always \
    --name registry	\
    -p 5000:5000 \
    -v registry-data:/var/lib/registry \
    registry
```

## 7.2 图形界面仓库

> 使用DockerCompose部署界面化仓库

```yaml
version: '3.0'
services:
  registry:
    image: registry
    volumes:
      - ./registry-data:/var/lib/registry
  ui:
    image: joxit/docker-registry-ui:static
    ports:
      - 8080:80
    environment:
      - REGISTRY_TITLE=我的私有仓库
      - REGISTRY_URL=http://registry:5000
    depends_on:
      - registry
```

配置信任地址：
```shell
# 打开要修改的文件
vi /etc/docker/daemon.json
# 添加内容：
"insecure-registries":["http://192.168.150.101:8080"]
# 重加载
systemctl daemon-reload
# 重启docker
systemctl restart docker
```

# 9. 镜像推送拉取

重新tag本地镜像：`docker tag nginx:latest 本地仓库名称:端口/nginx:1.0 `

推送镜像：`docker push 本地仓库名称:端口/nginx:1.0 `

拉取镜像：`docker pull 本地仓库名称:端口/nginx:1.0 `
