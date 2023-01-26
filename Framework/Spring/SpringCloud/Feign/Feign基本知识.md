# 1. 简单入门

> 食用此教程需要一定Spring、SpringMvc、SpringBoot和Mybatis知识。

项目采用的是Maven模块化创建的项目，其他具体依赖请浏览源码：[SpringCloudMall](https://github.com/xiaoyu2017/Mall)

1.依赖

```xml

<dependency>
    <groupId>org.springframework.cloud</groupId>
    <artifactId>spring-cloud-starter-openfeign</artifactId>
</dependency>
```

2.注入RestTemplate
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

3.测试
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








