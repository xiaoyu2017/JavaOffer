# 1. 简单入门

> 食用此教程需要一定Spring、SpringMvc、SpringBoot和Mybatis知识。

项目采用的是Maven模块化创建的项目，其他具体依赖请浏览源码：[SpringCloudMall](https://github.com/xiaoyu2017/Mall)

> RestTemplate远程调用

1.注入RestTemplate

```java

@SpringBootApplication
public class OrderApplication {

    public static void main(String[] args) {
        SpringApplication.run(OrderApplication.class, args);
    }

    // 注入RestTemplate
    @Bean
    public RestTemplate restTemplate() {
        return new RestTemplate();
    }
}
```

2.测试

```java

@Service
public class OrderServiceImpl implements OrderService {

    @Autowired
    OrderDao orderDao;

    @Autowired
    RestTemplate restTemplate;

    @Override
    public OrderUser getById(long id) {
        Order order = orderDao.selectById(id);
        OrderUser orderUser = new OrderUser();
        BeanUtils.copyProperties(order, orderUser);
        // 另一个服务的地址，返回后映射到的实体类
        User user = restTemplate.getForObject("http://127.0.0.1:12040/user/" + order.getUserId(), User.class);
        orderUser.setUser(user);
        return orderUser;
    }
}
```

# 2. 最佳实践

> RestTemplate确实可以远程调用，但是随着业务增多就很难维护。这时就可以使用Feign来实现。

## 2.1 Feign实现

1.依赖

```xml

<dependency>
    <groupId>org.springframework.cloud</groupId>
    <artifactId>spring-cloud-starter-openfeign</artifactId>
</dependency>
```

2.添加注解

```java
// Feign注解
@EnableFeignClients
@SpringBootApplication
public class OrderApplication {
    public static void main(String[] args) {
        ConfigurableApplicationContext context = SpringApplication.run(OrderApplication.class, args);
        System.out.println(context.getEnvironment().getProperty("mall"));
    }
}

```

3.远程调用接口

```java
// 表名访问的服务
@FeignClient("mall-user")
public interface UserClient {

    // 使用Controller注解即可
    @GetMapping("/user/{id}")
    User findById(@PathVariable("id") long id);
}

```

4.使用

```java

@Service
public class OrderServiceImpl implements OrderService {

    @Autowired
    OrderDao orderDao;

    @Autowired
    UserClient userClient;

    @Override
    public OrderUser getById(long id) {
        Order order = orderDao.selectById(id);
        OrderUser orderUser = new OrderUser();
        BeanUtils.copyProperties(order, orderUser);
        // 使用接口远程调用
        orderUser.setUser(userClient.findById(order.getUserId()));
        return orderUser;
    }
}

```

## 2.2 Feign优化

> Feign底层使用Http实现远程调用，实现使用的是第三方框架。默认使用的是`URLConnection`，此实现不支持连接池。`Apache HttpClient`和
> `OKHttp`是支持连接池的。

1.添加依赖
```xml
<!--httpClient的依赖，高版本SpringCloudAlibaba无需添加 -->
<dependency>
    <groupId>io.github.openfeign</groupId>
    <artifactId>feign-httpclient</artifactId>
</dependency>
```

2.添加配置
```yaml
feign:
  client:
    config:
      default: # default全局的配置
        loggerLevel: BASIC # 日志级别，BASIC就是基本的请求和响应信息
  httpclient:
    enabled: true # 开启feign对HttpClient的支持
    max-connections: 200 # 最大的连接数
    max-connections-per-route: 50 # 每个路径的最大连接数
```
## 2.3 最终实践

> 每个项目都需要远程访问别的服务，都需要创建Feign调用接口，这样存在重复，且目标服务接口使用不明。所以通常是将Feign单独成一个项目，大家共同
> 维护，将自家服务调用接口维护好即可。

单独出新项目后，FeignClient包路径可能存在差异，就有可能扫描不到，这是可以用注解参数解决：

`@EnableFeignClients(basePackages = "cn.itcast.feign.clients")`或`@EnableFeignClients(clients = {UserClient.class})`

# 3. 自定义配置

| 类型                   | 作用             | 说明                                                   |
| ---------------------- | ---------------- | ------------------------------------------------------ |
| **feign.Logger.Level** | 修改日志级别     | 包含四种不同的级别：NONE、BASIC、HEADERS、FULL         |
| feign.codec.Decoder    | 响应结果的解析器 | http远程调用的结果做解析，例如解析json字符串为java对象 |
| feign.codec.Encoder    | 请求参数编码     | 将请求参数编码，便于通过http请求发送                   |
| feign. Contract        | 支持的注解格式   | 默认是SpringMVC的注解                                  |
| feign. Retryer         | 失败重试机制     | 请求失败的重试机制，默认是没有，不过会使用Ribbon的重试 |

## 3.1 配置日志

```yaml
feign:
  client:
    config:
      mall-order: # 针对某个微服务的配置
        loggerLevel: FULL #  日志级别 
```

```yaml
feign:
  client:
    config:
      default: # 这里用default就是全局配置，如果是写服务名称，则是针对某个微服务的配置
        loggerLevel: FULL #  日志级别 
```

- NONE：不记录任何日志信息，这是默认值。
- BASIC：仅记录请求的方法，URL以及响应状态码和执行时间
- HEADERS：在BASIC的基础上，额外记录了请求和响应的头信息
- FULL：记录所有请求和响应的明细，包括头信息、请求体、元数据。

> 通过代码实现

```java
public class DefaultFeignConfiguration {
    @Bean
    public Logger.Level feignLogLevel() {
        return Logger.Level.BASIC; // 日志级别为BASIC
    }
}
```

如果要**全局生效**，将其放到启动类的@EnableFeignClients这个注解中：
`@EnableFeignClients(defaultConfiguration = DefaultFeignConfiguration .class) `


如果是**局部生效**，则把它放到对应的@FeignClient这个注解中：
`@FeignClient(value = "mall-order", configuration = DefaultFeignConfiguration .class) `