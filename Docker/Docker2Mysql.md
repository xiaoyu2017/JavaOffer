# Docker安装Mysql

## 1. 下载Mysql镜像

`docker pull mysql:latest`

## 2. 配置内容

```shell
docker run --name MysqlTset --privileged=true -v /Users/yujiangzhong/DockerData/mysql/mysql0/data:/var/lib/mysql -v /Users/yujiangzhong/DockerData/mysql/mysql0/conf:/etc/mysql/conf.d -v /Users/yujiangzhong/DockerData/mysql/mysql0/log:/var/log/mysql -e MYSQL_ROOT_PASSWORD=root -p 33060:3306 -d mysql:8.0.27
```