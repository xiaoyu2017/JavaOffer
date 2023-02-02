# 1. 消息可靠性

其中的每一步都可能导致消息丢失，常见的丢失原因包括：

- 发送时丢失：
    - 生产者发送的消息未送达exchange
    - 消息到达exchange后未到达queue
- MQ宕机，queue将消息丢失
- consumer接收到消息后未消费就宕机

针对这些问题，RabbitMQ分别给出了解决方案：

- 生产者确认机制
- mq持久化
- 消费者确认机制
- 失败重试机制

## 1.1 生产者确认机制

> RabbitMQ提供了publisher confirm机制来避免消息发送到MQ过程中丢失。这种机制必须给每个消息指定一个**唯一ID**。消息发送到MQ以后，会返回一个结果给发送者，表示消息是否处理成功。

返回结果有两种方式：

- publisher-confirm，发送者确认
    - 消息成功投递到交换机，返回ack
    - 消息未投递到交换机，返回nack
- publisher-return，发送者回执
    - 消息投递到交换机了，但是没有路由到队列。返回ACK，及路由失败原因。

示例：

```yaml
server:
  port: 12491

spring:
  application:
    name: mall-logistics
  rabbitmq:
    host: 127.0.0.1 # 主机名
    port: 5672 # 端口
    virtual-host: / # 虚拟主机
    username: admin # 用户名
    password: admin # 密码
    publisher-confirm-type: correlated  #开启publisher-confirm
    publisher-returns: true #开启publish-return功能
    template:
      mandatory: true #定义消息路由失败时的策略。true，则调用ReturnCallback；false：则直接丢弃消息
```

```java
// 定义returns回执方法
@Slf4j
@Configuration
public class CommonConfig implements ApplicationContextAware {
    @Override
    public void setApplicationContext(ApplicationContext applicationContext) throws BeansException {
        // 获取RabbitTemplate
        RabbitTemplate rabbitTemplate = applicationContext.getBean(RabbitTemplate.class);
        // 设置ReturnCallback
        rabbitTemplate.setReturnCallback((message, replyCode, replyText, exchange, routingKey) -> {
            // 投递失败，记录日志
            log.info("消息发送失败，应答码{}，原因{}，交换机{}，路由键{},消息{}",
                    replyCode, replyText, exchange, routingKey, message.toString());
            // 如果有业务需要，可以重发消息
        });
    }
}
```

```java
// confirm发送确认
@SpringBootTest
public class LogisticsAppTest {

    @Autowired
    private RabbitTemplate rabbitTemplate;

    public void testSendMessage2SimpleQueue() throws InterruptedException {
        // 1.消息体
        String message = "hello, spring amqp!";
        // 2.全局唯一的消息ID，需要封装到CorrelationData中
        CorrelationData correlationData = new CorrelationData(UUID.randomUUID().toString());
        // 3.添加callback
        correlationData.getFuture().addCallback(
                result -> {
                    if (result.isAck()) {
                        // 3.1.ack，消息成功
                        log.debug("消息发送成功, ID:{}", correlationData.getId());
                    } else {
                        // 3.2.nack，消息失败
                        log.error("消息发送失败, ID:{}, 原因{}", correlationData.getId(), result.getReason());
                    }
                },
                ex -> log.error("消息发送异常, ID:{}, 原因{}", correlationData.getId(), ex.getMessage())
        );
        // 4.发送消息
        rabbitTemplate.convertAndSend("task.direct", "task", message, correlationData);

        // 休眠一会儿，等待ack回执
        Thread.sleep(2000);
    }
}
```

## 1.2 消息持久化

> 生产者确认可以确保消息投递到RabbitMQ的队列中，但是消息发送到RabbitMQ以后，如果突然宕机，也可能导致消息丢失。
> 要想确保消息在RabbitMQ中安全保存，必须开启消息持久化机制。

- 交换机持久化
- 队列持久化
- 消息持久化

### 1.2.1 交换机持久化

> RabbitMQ中交换机默认是非持久化的，mq重启后就丢失。

```java
// SpringAMQP
@Configuration
public class CommonConfig {
    @Bean
    public DirectExchange simpleExchange() {
        // 三个参数：交换机名称、是否持久化、当没有queue与其绑定时是否自动删除
        return new DirectExchange("simple.direct", true, false);
    }
}
```

**事实上，默认情况下，由SpringAMQP声明的交换机都是持久化的。**

### 1.2.2 队列持久化

> RabbitMQ中队列默认是非持久化的，mq重启后就丢失。

```java
// SpringAMQP
@Configuration
public class CommonConfig {
    @Bean
    public Queue simpleQueue() {
        // 使用QueueBuilder构建队列，durable就是持久化的
        return QueueBuilder.durable("simple.queue").build();
    }
}
```

**事实上，默认情况下，由SpringAMQP声明的队列都是持久化的。**

### 1.2.3 消息持久化

利用SpringAMQP发送消息时，可以设置消息的属性（MessageProperties），指定delivery-mode：

- 1：非持久化
- 2：持久化

**默认情况下，SpringAMQP发出的任何消息都是持久化的，不用特意指定。**











