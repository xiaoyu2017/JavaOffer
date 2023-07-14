# 1. Linux

> 需要Linux联网

## 1.1 安装开发库

`yum install -y pcre-devel openssl-devel gcc --skip-broken`

## 1.2 系统加载openresty仓库

`yum-config-manager --add-repo https://openresty.org/package/centos/openresty.repo`

以上命令提示不存在则运行`yum install -y yum-utils`，然后运行上面命令。

## 1.3 安装OpenResty

`yum install -y openresty`

## 1.4 安装opm

opm是OpenResty的一个管理工具，可以帮助我们安装一个第三方的Lua模块。

`yum install -y openresty-opm`

## 1.5 目录结构

默认情况下，OpenResty安装的目录是：/usr/local/openresty

## 1.6 配置Nginx

打开配置：`vi /etc/profile`

添加配置：

```conf
export NGINX_HOME=/usr/local/openresty/nginx
export PATH=${NGINX_HOME}/sbin:$PATH
```

**NGINX_HOME：后面是OpenResty安装目录下的nginx的目录**

配置刷新：`source /etc/profile`

1.7 运行

进入OpenResty目录下Nginx目录：

```shell
# 启动nginx
nginx
# 重新加载配置
nginx -s reload
# 停止
nginx -s stop
```








