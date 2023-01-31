# 1. 概述

> 2007年，Rabbit 技术公司基于 AMQP 标准开发的 RabbitMQ 1.0 发布。RabbitMQ 采用 Erlang 语言开发。
> Erlang 语言由 Ericson 设计，专门为开发高并发和分布式系统的一种语言，在电信领域使用广泛。

![](https://raw.githubusercontent.com/xiaoyu2017/JavaOffer/master/img/rabbit2.png)

## 1.1 同步和异步调用

1. 同步调用优劣
    1. 优势：立即执行，可以很快的结果。
    2. 劣势：
        1. 耦合度高：服务功能修改可能会导致其他服务也要修改
        2. 性能下降：在比较长的调用链中，需要等待时间较长。
        3. 资源消耗：长时间的等待就会导致无法极快释放
        4. 级联失败：有一个服务出现问题，其他服务也会出现问题，像多米诺骨牌一样。
2. 异步调用优劣
    1. 优势
        1. 吞吐量提高：接收者发出处理消息后直接返回无需等待，异步调用继续处理。
        2. 故障隔离：服务调用隔离，不存在级联关系。
        3. 资源释放快。
        4. 耦合较低，每个服务灵活拔插、荣义替换。
        5. 流量消峰：无论接收者请求量多大，MQ接收到消息后消费者按部就班按照自己速度处理。
    2. 劣势
        1. 一致问题
        2. 结果复杂，出错不好追踪，服务不好管理。
        3. 需要依赖MQ的高可靠、安全和性能

## 1.2 RabbitMQ角色

![](https://raw.githubusercontent.com/xiaoyu2017/JavaOffer/master/img/rabbit0.png)

- publisher：生产者
- consumer：消费者
- exchange个：交换机，负责消息路由
- queue：队列，存储消息
- virtualHost：虚拟主机，隔离不同租户的exchange、queue、消息的隔离

## 1.3 5种消费模型

![](https://raw.githubusercontent.com/xiaoyu2017/JavaOffer/master/img/rabbit1.png)

# 2. 安装

> 基于Docker安装

下载镜像：`docker pull rabbitmq:3.9.27`

创建容器：

```shell
docker run \
 -e RABBITMQ_DEFAULT_USER=admin \
 -e RABBITMQ_DEFAULT_PASS=admin \
 --name mq \
 --hostname mq1 \
 -p 15672:15672 \
 -p 5672:5672 \
 -d \
 rabbitmq:3.9.27
```

安装界面插件：`docker exec -it rabbit rabbitmq-plugins enable rabbitmq_management`

# 3. 消费模型

## 3.1 BasicQueue

![](https://raw.githubusercontent.com/xiaoyu2017/JavaOffer/master/img/rabbitmq3.png)

- publisher：消息发布者，将消息发送到队列queue
- queue：消息队列，负责接受并缓存消息
- consumer：订阅队列，处理队列中的消息

依赖：

```xml

<dependencies>
    <!--AMQP依赖，包含RabbitMQ-->
    <dependency>
        <groupId>org.springframework.boot</groupId>
        <artifactId>spring-boot-starter-amqp</artifactId>
    </dependency>
    <!--单元测试-->
    <dependency>
        <groupId>org.springframework.boot</groupId>
        <artifactId>spring-boot-starter-test</artifactId>
    </dependency>
    <dependency>
        <groupId>com.fasterxml.jackson.core</groupId>
        <artifactId>jackson-databind</artifactId>
    </dependency>
</dependencies>
```

生产者：

```java
public class PublisherTest {
    @Test
    public void testSendMessage() throws IOException, TimeoutException {
        // 1.建立连接
        ConnectionFactory factory = new ConnectionFactory();

        // 1.1.设置连接参数，分别是：主机名、端口号、vhost、用户名、密码
        factory.setHost("127.0.0.1");
        factory.setPort(5672);
        factory.setVirtualHost("/");
        factory.setUsername("admin");
        factory.setPassword("admin");

        // 1.2.建立连接
        Connection connection = factory.newConnection();

        // 2.创建通道Channel
        Channel channel = connection.createChannel();

        // 3.创建队列
        String queueName = "simple.queue";
        channel.queueDeclare(queueName, false, false, false, null);

        // 4.发送消息
        String message = "hello, rabbitmq!";
        channel.basicPublish("", queueName, null, message.getBytes());
        System.out.println("发送消息成功：【" + message + "】");

        // 5.关闭通道和连接
        channel.close();
        connection.close();
    }
}
```

消费者：

```java
public class ConsumerTest {
    public static void main(String[] args) throws IOException, TimeoutException {
        // 1.建立连接
        ConnectionFactory factory = new ConnectionFactory();
        // 1.1.设置连接参数，分别是：主机名、端口号、vhost、用户名、密码
        factory.setHost("127.0.0.1");
        factory.setPort(5672);
        factory.setVirtualHost("/");
        factory.setUsername("admin");
        factory.setPassword("admin");
        // 1.2.建立连接
        Connection connection = factory.newConnection();

        // 2.创建通道Channel
        Channel channel = connection.createChannel();

        // 3.创建队列
        String queueName = "simple.queue";
        channel.queueDeclare(queueName, false, false, false, null);

        // 4.订阅消息
        channel.basicConsume(queueName, true, new DefaultConsumer(channel) {
            @Override
            public void handleDelivery(String consumerTag, Envelope envelope,
                                       AMQP.BasicProperties properties, byte[] body) throws IOException {
                // 5.处理消息
                String message = new String(body);
                System.out.println("接收到消息：【" + message + "】");
            }
        });
        System.out.println("等待接收消息。。。。");
    }
}
```

### 3.1.1 基于SpringBoot实现

生产者：

```yaml
spring:
  rabbitmq:
    host: 127.0.0.1 # 主机名
    port: 5672 # 端口
    virtual-host: / # 虚拟主机
    username: admin # 用户名
    password: admin # 密码
```

```java

@SpringBootTest
public class SpringAmqpTest {

    @Autowired
    private RabbitTemplate rabbitTemplate;

    @Test
    public void testSimpleQueue() {
        // 队列名称
        String queueName = "simple.queue";
        // 消息
        String message = "hello, spring amqp!";
        // 发送消息
        rabbitTemplate.convertAndSend(queueName, message);
    }
}
```

消费者：

```yaml
spring:
  rabbitmq:
    host: 127.0.0.1 # 主机名
    port: 5672 # 端口
    virtual-host: / # 虚拟主机
    username: admin # 用户名
    password: admin # 密码
```

```java
// 组装监听者
@Component
public class SpringRabbitListener {

    // 监听者配置
    @RabbitListener(queues = "simple.queue")
    public void listenSimpleQueueMessage(String msg) throws InterruptedException {
        System.out.println("spring 消费者接收到消息：【" + msg + "】");
    }
}
```

## 3.2 WorkQueue

![](https://raw.githubusercontent.com/xiaoyu2017/JavaOffer/master/img/rabbitmq4.png)

生产者：

```java

@SpringBootTest
public class SpringAmqpTest {

    @Autowired
    private RabbitTemplate rabbitTemplate;

    @Test
    public void testSimpleQueue() {
        // 队列名称
        String queueName = "simple.queue";
        // 消息
        String message = "hello, spring amqp!";

        for (int i = 0; i < 50; i++) {
            // 发送消息
            rabbitTemplate.convertAndSend(queueName, message + i);
            Thread.sleep(20);
        }
    }
}
```

消费者：

```java

@Component
public class SpringRabbitListener {
    @RabbitListener(queues = "simple.queue")
    public void listenWorkQueue1(String msg) throws InterruptedException {
        System.out.println("消费者1接收到消息：【" + msg + "】" + LocalTime.now());
        Thread.sleep(20);
    }

    @RabbitListener(queues = "simple.queue")
    public void listenWorkQueue2(String msg) throws InterruptedException {
        System.err.println("消费者2........接收到消息：【" + msg + "】" + LocalTime.now());
        Thread.sleep(200);
    }
}
```

**在加了随眠后，执行对比发现1执行很快，2需要的时间较长。默认是一下拿很多，这就导致能者等待，不行的还在拼命。**

设置每次只拿一个，这样就会发生能者多劳：

```yaml
spring:
  rabbitmq:
    listener:
      simple:
        prefetch: 1 # 每次只能获取一条消息，处理完成才能获取下一个消息
```

## 3.3 发布、订阅

![](https://raw.githubusercontent.com/xiaoyu2017/JavaOffer/master/img/rabbitmq5.png)

- Publisher：生产者，也就是要发送消息的程序，但是不再发送到队列中，而是发给X（交换机）
- Exchange：交换机，图中的X。一方面，接收生产者发送的消息。另一方面，知道如何处理消息，例如递交给某个特别队列、递交给所有队列、或是将消息丢弃。到底如何操作，取决于Exchange的类型。Exchange有以下3种类型：
    - Fanout：广播，将消息交给所有绑定到交换机的队列
    - Direct：定向，把消息交给符合指定routing key 的队列
    - Topic：通配符，把消息交给符合routing pattern（路由模式） 的队列
- Consumer：消费者，与以前一样，订阅队列，没有变化
- Queue：消息队列也与以前一样，接收消息、缓存消息。

### 3.3.1 Fanout

![](https://raw.githubusercontent.com/xiaoyu2017/JavaOffer/master/img/rabbitmq6.png)

配置基本信息

```java

@Configuration
public class RabbitFanoutConfig {

    /**
     * 声明交换机
     *
     * @return Fanout类型交换机
     */
    @Bean
    public FanoutExchange fanoutExchange() {
        return new FanoutExchange("mall.fanout");
    }

    /**
     * 第1个队列
     */
    @Bean
    public Queue fanoutQueue1() {
        return new Queue("fanout.queue1");
    }

    /**
     * 绑定队列和交换机
     */
    @Bean
    public Binding bindingQueue1(Queue fanoutQueue1, FanoutExchange fanoutExchange) {
        return BindingBuilder.bind(fanoutQueue1).to(fanoutExchange);
    }

    /**
     * 第2个队列
     */
    @Bean
    public Queue fanoutQueue2() {
        return new Queue("fanout.queue2");
    }

    /**
     * 绑定队列和交换机
     */
    @Bean
    public Binding bindingQueue2(Queue fanoutQueue2, FanoutExchange fanoutExchange) {
        return BindingBuilder.bind(fanoutQueue2).to(fanoutExchange);
    }

    /**
     * rabbit会把对象序列化，此注解会把序列化编程json数据类型。
     */
    @Bean
    public MessageConverter jsonMessageConverter() {
        return new Jackson2JsonMessageConverter();
    }
}

```

```java
// 生产者
@SpringBootTest
public class SpringAmqpTest {

    @Autowired
    private RabbitTemplate rabbitTemplate;

    @Test
    public void testSimpleExchange() {
        // 交换机名称
        String exchangeName = "mall.fanout";
        // 消息
        String message = "hello, spring amqp!";
        // 发送消息
        rabbitTemplate.convertAndSend(exchangeName, "", message);
    }
}
```

```java

@Component
public class SpringRabbitListener {
    @RabbitListener(queues = "fanout.queue1")
    public void listenSimpleQueueMessage1(String msg) throws InterruptedException {
        System.out.println("spring1 消费者接收到消息：【" + msg + "】");
    }

    @RabbitListener(queues = "fanout.queue2")
    public void listenSimpleQueueMessage2(String msg) throws InterruptedException {
        System.out.println("spring2 消费者接收到消息：【" + msg + "】");
    }
}
```

### 3.3.2 Direct

![](https://raw.githubusercontent.com/xiaoyu2017/JavaOffer/master/img/rabbitmq7.png)

- 队列与交换机的绑定，不能是任意绑定了，而是要指定一个`RoutingKey`（路由key）
- 消息的发送方在 向 Exchange发送消息时，也必须指定消息的 `RoutingKey`。
- Exchange不再把消息交给每一个绑定的队列，而是根据消息的`Routing Key`进行判断，只有队列的`Routingkey`与消息的 `Routing key`完全一致，才会接收到消息

```java
// 生产者
@SpringBootTest
public class SpringAmqpTest {

    @Autowired
    private RabbitTemplate rabbitTemplate;

    @Test
    public void testSendDirectExchange() {
        // 交换机名称
        String exchangeName = "mall.direct";
        // 消息
        String message = "红色警报！日本乱排核废水，导致海洋生物变异，惊现哥斯拉！";
        // 发送消息，routingKey为red
        rabbitTemplate.convertAndSend(exchangeName, "red", message);
    }
}
```

```java
// 消费者
@Component
public class SpringRabbitListener {
    @RabbitListener(bindings = @QueueBinding(
            value = @Queue(name = "direct.queue1"),
            exchange = @Exchange(name = "mall.direct", type = ExchangeTypes.DIRECT),
            key = {"red", "blue"}
    ))
    public void listenDirectQueue1(String msg) {
        System.out.println("消费者接收到direct.queue1的消息：【" + msg + "】");
    }

    @RabbitListener(bindings = @QueueBinding(
            value = @Queue(name = "direct.queue2"),
            exchange = @Exchange(name = "mall.direct", type = ExchangeTypes.DIRECT),
            key = {"red", "yellow"}
    ))
    public void listenDirectQueue2(String msg) {
        System.out.println("消费者接收到direct.queue2的消息：【" + msg + "】");
    }
}
```

### 3.3.3 Topic

> `Topic`类型的`Exchange`与`Direct`相比，都是可以根据`RoutingKey`把消息路由到不同的队列。只不过`Topic`类型`Exchange`可以让队列在绑定`Routing key` 的时候使用通配符！

通配符规则：

- `#`：匹配一个或多个词
- `*`：匹配不多不少恰好1个词

举例：

- `item.#`：能够匹配`item.spu.insert` 或者 `item.spu`
- `item.*`：只能匹配`item.spu`

![](https://raw.githubusercontent.com/xiaoyu2017/JavaOffer/master/img/rabbitmq8.png)

```java

@SpringBootTest
public class LogisticsAppTest {

    @Autowired
    private RabbitTemplate rabbitTemplate;

    @Test
    public void testSendTopicExchange() {
        // 交换机名称
        String exchangeName = "mall.topic";
        // 消息
        String message = "喜报！孙悟空大战哥斯拉，胜!";
        // 发送消息
        rabbitTemplate.convertAndSend(exchangeName, "china.good", message);
    }

}
```

```java

@Component
public class SpringRabbitListener {
    @RabbitListener(bindings = @QueueBinding(
            value = @Queue(name = "topic.queue1"),
            exchange = @Exchange(name = "mall.topic", type = ExchangeTypes.TOPIC),
            key = "china.#"
    ))
    public void listenTopicQueue1(String msg) {
        System.out.println("消费者接收到topic.queue1的消息：【" + msg + "】");
    }

    @RabbitListener(bindings = @QueueBinding(
            value = @Queue(name = "topic.queue2"),
            exchange = @Exchange(name = "mall.topic", type = ExchangeTypes.TOPIC),
            key = "#.news"
    ))
    public void listenTopicQueue2(String msg) {
        System.out.println("消费者接收到topic.queue2的消息：【" + msg + "】");
    }
}
```

# 4. 消息转换器

> rabbitMQ默认是吧对象进行序列化，这会导致数据不安全，而且数据会很大。这时可以通过设置消息转换器来改变内容格式。

```xml
<!--json依赖-->
<dependency>
    <groupId>com.fasterxml.jackson.core</groupId>
    <artifactId>jackson-databind</artifactId>
</dependency>
```

```java
// 装配
public class RabbitFanoutConfig {
    @Bean
    public MessageConverter jsonMessageConverter() {
        return new Jackson2JsonMessageConverter();
    }
}
```
