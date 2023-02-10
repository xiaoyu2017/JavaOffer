# 1. 概述

## 1.1 服务雪崩问题

当一个请求依赖多个服务，服务正常则无关紧要。当一个服务出现问题，如下图I服务出现问题。此时服务机会被阻塞。

![](../../../../img/sentinel0.png)

线程被阻塞，无法短时间释放就会导致大量的线程被阻塞在服务器中：

![](../../../../img/sentinel1.png)

服务器的线程是有限的，当资源耗尽就会出现其他服务也不能正常使用，随着时间的推移产生级联瘫痪，类似雪崩一样一发不可收拾。

![](../../../../img/sentinel2.png)

## 1.2 雪崩问题处理

- 超时处理：设定超时时间，请求超过一定时间没有响应就返回错误信息，不会无休止等待
- 仓壁模式：我们可以限定每个业务能使用的线程数，避免耗尽整个tomcat的资源，因此也叫线程隔离。
- 断路器模式：由**断路器**统计业务执行的异常比例，如果超出阈值则会**熔断**该业务，拦截访问该业务的一切请求。
- **流量控制**：限制业务访问的QPS，避免服务因流量的突增而故障。

## 1.3 初识Sentinel

> Sentinel是阿里巴巴开源的一款微服务流量控制组件。 [官网地址](https://sentinelguard.io/zh-cn/index.html)
>
> 测试工具可以使用 [Apache Jmeter](https://jmeter.apache.org/download_jmeter.cgi)

特征：

- **丰富的应用场景**：Sentinel 承接了阿里巴巴近 10 年的双十一大促流量的核心场景，例如秒杀（即突发流量控制在系统容量可以承受的范围）、消息削峰填谷、集群流量控制、实时熔断下游不可用应用等。
- **完备的实时监控**：Sentinel 同时提供实时的监控功能。您可以在控制台中看到接入应用的单台机器秒级数据，甚至 500 台以下规模的集群的汇总运行情况。
- **广泛的开源生态**：Sentinel 提供开箱即用的与其它开源框架/库的整合模块，例如与 Spring Cloud、Dubbo、gRPC 的整合。您只需要引入相应的依赖并进行简单的配置即可快速地接入 Sentinel。
- **完善的** **SPI** **扩展点**：Sentinel 提供简单易用、完善的 SPI 扩展接口。您可以通过实现扩展接口来快速地定制逻辑。例如定制规则管理、适配动态数据源等。

## 1.4 整合Sentinel

1.依赖

```xml
<!--sentinel-->
<dependency>
    <groupId>com.alibaba.cloud</groupId>
    <artifactId>spring-cloud-starter-alibaba-sentinel</artifactId>
</dependency>
```

2.配置

```yaml
server:
  port: 8088
spring:
  cloud:
    sentinel:
      transport:
        dashboard: localhost:8080
```

3.访问服务接口后就会触发Sentinel监控，访问后打开http://localhost:8080即可

# 2. 流量控制

> 雪崩问题虽然有四种方案，但是限流是避免服务因突发的流量而发生故障，是对微服务雪崩问题的预防。

## 2.1 簇点链路

> 当请求进入微服务时，首先会访问DispatcherServlet，然后进入Controller、Service、Mapper，这样的一个调用链就叫做**簇点链路**。簇点链路中被监控的每一个接口就是一个**资源**。
>
> 默认情况下sentinel会监控SpringMVC的每一个端点（Endpoint，也就是controller中的方法），因此SpringMVC的每一个端点（Endpoint）就是调用链路中的一个资源。

在sentinel中可以对资源进行设置：

- 流控：流量控制
- 降级：降级熔断
- 热点：热点参数限流，是限流的一种
- 授权：请求的权限控制

## 2.2 流量控制

设置QPS：直连为默认方式

![](../../../../img/sentinel3.png)

在添加限流规则时，点击高级选项，可以选择三种**流控模式**：

- 直接：统计当前资源的请求，触发阈值时对当前资源直接限流，也是默认的模式
- 关联：统计与当前资源相关的另一个资源，触发阈值时，对当前资源限流
- 链路：统计从指定链路访问到本资源的请求，触发阈值时，对指定链路限流

### 2.2.1 关联设置

![](../../../../img/sentinel4.png)

当对`/write`的访问量达到设置值，也会触发`/read`的流量限制。

### 2.2.1 链路设置

![](../../../../img/sentinel5.png)

`/test1`和`/test2`同时访问`/common`，现在只限制`/test2`发过来的请求。

**当不是远程调用时，sentinel是无法统计被调用的service方法的，这时需要手动添加资源**

```java
public class CommonServiceImpl implements CommonService {
    // 手动添加资源
    @SentinelResource("common")
    public void queryGoods() {
        System.err.println("查询商品");
    }
}
```

**sentinel默认为进入SpringMvc所有请求都设置了相同的root资源，这样会导致链路模式失效，通过以下配置修改**

```yaml
spring:
  cloud:
    sentinel:
      web-context-unify: false # 关闭context整合
```

## 2.3 控流效果

在高级选项中包括以下三个选项:

- 快速失败：达到阈值后，新的请求会被立即拒绝并抛出FlowException异常。是默认的处理方式。
- warm up：预热模式，对超出阈值的请求同样是拒绝并抛出异常。但这种模式阈值会动态变化，从一个较小值逐渐增加到最大阈值。
- 排队等待：让所有的请求按照先后次序排队执行，两个请求的间隔不能小于指定时长

### 2.3.1 warm up

阈值一般是一个微服务能承担的最大QPS，但是一个服务刚刚启动时，一切资源尚未初始化（**冷启动**），如果直接将QPS跑到最大值，可能导致服务瞬间宕机。

warm up也叫**预热模式**，是应对服务冷启动的一种方案。请求阈值初始值是`maxThreshold / coldFactor`，持续指定时长后，逐渐提高到maxThreshold值。而coldFactor的默认值是3.

例如，我设置QPS的maxThreshold为10，预热时间为5秒，那么初始阈值就是 10 / 3 ，也就是3，然后在5秒后逐渐增长到10.

### 2.3.2 排队等待

> 排队等待则是让所有请求进入一个队列中，然后按照阈值允许的时间间隔依次执行。后来的请求必须等待前面执行完成，如果请求预期的等待时间超出最大时长，则会被拒绝。

工作原理:

例如：QPS = 5，意味着每200ms处理一个队列中的请求；timeout = 2000，意味着**预期等待时长**超过2000ms的请求会被拒绝并抛出异常。

那什么叫做预期等待时长呢？

比如现在一下子来了12 个请求，因为每200ms执行一个请求，那么：

- 第6个请求的**预期等待时长** = 200 * （6 - 1） = 1000ms
- 第12个请求的预期等待时长 = 200 * （12-1） = 2200ms

## 2.4 热点参数限流

> 之前的限流是统计访问某个资源的所有请求，判断是否超过QPS阈值。而热点参数限流是**分别统计参数值相同的请求**，判断是否超过QPS阈值。

例如根据订单id进行查询：请求的每次连接不同

![](../../../../img/sentinel6.png)

示例：

```java
public class OrderController {
    @Autowired
    OrderService orderService;

    // 标记这是一个热点请求
    @SentinelResource("hot")
    @GetMapping("/order/{id}")
    public Order getOrderById(@PathVariable long id) {
        return orderService.queryOrderById(id);
    }
}
```

![](../../../../img/sentinel7.png)

# 3. 隔离和降级

> 限流是一种预防措施，虽然限流可以尽量避免因高并发而引起的服务故障，但服务还会因为其它原因而故障。而要将这些故障控制在一定范围，
> 避免雪崩，就要靠**线程隔离**（舱壁模式）和**熔断降级**手段

**线程隔离**：调用者在调用服务提供者时，给每个调用的请求分配独立线程池，出现故障时，最多消耗这个线程池内资源，避免把调用者的所有资源耗尽。
![](../../../../img/sentinel8.png)
**熔断降级**：是在调用方这边加入断路器，统计对服务提供者的调用，如果调用的失败比例过高，则熔断该业务，不允许访问该服务的提供者了。
![](../../../../img/sentinel9.png)

## 3.1 Sentinel整合Feign

### 3.1.1 添加配置

```yaml
feign:
  sentinel:
    enabled: true # 开启feign对sentinel的支持
```

### 3.1.2 失败处理类

给FeignClient编写失败后的降级逻辑

- 方式一：FallbackClass，无法对远程调用的异常做处理
- 方式二：FallbackFactory，可以对远程调用的异常做处理，我们选择这种

```java
// 异常处理类
@Slf4j
public class OrderFallbackFactory implements FallbackFactory<OrderClient> {
    @Override
    public OrderClient create(Throwable cause) {
        return id -> {
            log.error("查询订单异常", cause);
            return new Order();
        };
    }
}

// feign客户端添加降级处理方式
@FeignClient(value = "mall-order", fallbackFactory = OrderFallbackFactory.class)
public interface OrderClient {

    /**
     * 通过user id获得user信息
     *
     * @param id id
     * @return User
     */
    @GetMapping("/order/{id}")
    Order findById(@PathVariable("id") long id);
}
```

### 3.1.3 装配处理类
```java
@Configuration
public class SentinelConfig {
    @Bean
    public OrderFallbackFactory orderFallbackFactory() {
        return new OrderFallbackFactory();
    }
}
```

> 重启项目再访问查询，就可以在控制台上查看到新的簇点链路。

