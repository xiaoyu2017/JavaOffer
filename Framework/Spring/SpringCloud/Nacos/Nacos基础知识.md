# 1. Nacos概述

> alibaba推出的注册和配置中心。他是一个单独的软件，官网下载直接运行即可，项目通过一些配置即可被管理。

# 2. 注册中心

## 2.1 注册中心简单入门

1.依赖

```xml
<!--父项目-->
<dependency>
    <groupId>com.alibaba.cloud</groupId>
    <artifactId>spring-cloud-alibaba-dependencies</artifactId>
    <version>2.2.6.RELEASE</version>
    <type>pom</type>
    <scope>import</scope>
</dependency>
```

```xml
<!--子项目-->
<dependency>
    <groupId>com.alibaba.cloud</groupId>
    <artifactId>spring-cloud-starter-alibaba-nacos-discovery</artifactId>
</dependency>
```

```yaml
spring:
  cloud:
    nacos:
      server-addr: localhost:8848 #注册中心地址
```

## 2.2 集群

> 服务可能存在多个地方，访问这些项目肯定在同一地区会更快点，nacos是通过集群来进行管理，这时访问当地服务会优先。

![](../../../../img/nacos2.png)

```yaml
spring:
  cloud:
    nacos:
      server-addr: localhost:8848
      discovery:
        cluster-name: HZ # 集群名称
```

> 配置集群还需要更改赋值均衡策略，默认策略不支持同集群访问。Nacos提供了NacosRule策略。

```yaml
mall-user:
  ribbon:
    NFLoadBalancerRuleClassName: com.alibaba.cloud.nacos.ribbon.NacosRule # 负载均衡规则 
```

## 2.3 权重配置

> 因为机器的不同，所以相同服务访问速度存在差别，这是可以通过权重来设置访问偏向值。

在nacos控制台找到服务，点击编辑，可以在设置里面修改权重，为0的话此服务不会被访问。

![](../../../../img/nacos0.png)
![](../../../../img/nacos1.png)

## 2.4 环境隔离

> nacos提供了namespace来实现环境的隔离。namespace之间相互隔离，服务之间不可见。

![](../../../../img/nacos3.png)

nacos有个默认空间，此空间是默认值。
![](../../../../img/nacos4.png)

点击新建命名空间即可:
![](../../../../img/nacos5.png)
![](../../../../img/nacos6.png)

微服务配置，重启即可：

```yaml
spring:
  cloud:
    nacos:
      server-addr: localhost:8848
      discovery:
        cluster-name: SH
        namespace: 02d2e7ec-66de-441d-bef8-f1a7e03b6fd2 # 命名空间，填ID
```

![](../../../../img/nacos7.png)

## 2.5 服务类型

Nacos的服务实例分为两种类型：

- 临时实例：如果实例宕机超过一定时间，会从服务列表剔除，默认的类型。
- 非临时实例：如果实例宕机，不会从服务列表剔除，也可以叫永久实例。

```yaml
spring:
  cloud:
    nacos:
      discovery:
        ephemeral: false # 设置为非临时实例
```

![](../../../../img/nacos8.png)

临时实例：采用心跳检测服务健康

非临时实例：采用主动询问检测服务健康




