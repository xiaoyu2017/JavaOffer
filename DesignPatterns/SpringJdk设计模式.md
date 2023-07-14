# 工厂模式
Spring使用BeanFactory或ApplicationContext工厂创建Bean对象。
BeanFactory：延迟注入，需要时才创建。内存占用少，启动快。使用时创建，第一次访问时间较长。
ApplicationContext：一次性创建，启动创建所有。对BeanFactory的扩展。

ApplicationContext实现类：
    ClassPathXmlApplication：资源路径加载类
    FileSystemXmlApplication：系统文件加载类
    XmlWebApplicationContext：web系统中加载类

```java
public class AppliactionTest {
    @Test
    public void applicationTest() {
        ApplicationContext applicationContext = new FileSystemXmlApplicationContext(
                "file:/Users/yujiangzhong/Desktop/Student/application-bean.xml");
        CatBean catBean = (CatBean) applicationContext.getBean("catBean");
        catBean.setName("haha");
        catBean.setAge((byte) 3);
        catBean.setSex("male");
        System.out.println(catBean);
    }
}
```

# 单例模式
> Spring中Bean的默认作用域是单例的（singleton）。Spring使用ConcurrentHashMap加synchronized实现单例创建。

```java
// 通过 ConcurrentHashMap（线程安全） 实现单例注册表
private final Map<String, Object> singletonObjects = new ConcurrentHashMap<String, Object>(64);

public Object getSingleton(String beanName, ObjectFactory<?> singletonFactory) {
        Assert.notNull(beanName, "'beanName' must not be null");
        synchronized (this.singletonObjects) {
            // 检查缓存中是否存在实例  
            Object singletonObject = this.singletonObjects.get(beanName);
            if (singletonObject == null) {
                //...省略了很多代码
                try {
                    singletonObject = singletonFactory.getObject();
                }
                //...省略了很多代码
                // 如果实例对象在不存在，我们注册到单例注册表中。
                addSingleton(beanName, singletonObject);
            }
            return (singletonObject != NULL_OBJECT ? singletonObject : null);
        }
    }
    //将对象添加到单例注册表
    protected void addSingleton(String beanName, Object singletonObject) {
            synchronized (this.singletonObjects) {
                this.singletonObjects.put(beanName, (singletonObject != null ? singletonObject : NULL_OBJECT));

            }
        }
}
```

好处：
- 需要频繁使用的对象，减少创建花费时间。对于体积庞大对象，减少频繁创建的资源消耗。
- 减少new关键字使用，减少内存操作，减少GC影响。 

# 代理模式
Spring使用动态代理，被代理类实现接口则使用JDK代理，否则使用CGLIB。

# 模板模式
模板方法模式是一种行为设计模式，它定义一个操作中的算法的骨架，而将一些步骤延迟到子类中。 模板方法使得子类可以不改变一个算法的结构即可重定义该算法的某些特定步骤的实现方式。

Spring 中 jdbcTemplate、hibernateTemplate 等以 Template 结尾的对数据库操作的类，它们就使用到了模板模式。

# 观察者模式
> Spring中事件驱动就是观察者模式。观察者模式和发布订阅很类似，但还是有细微区别。

事件驱动三个部分：
ApplicationEvent：事件本身，自定义事件需要继承此类。
ApplicationEventPublisherAware：事件调用者，指定调用事件。ApplicationContext实现了该接口，ApplicationEventPublisher在Spring4.2后自定注册到容器中。
ApplicationListener：事件监听者，实现此类即可。Spring4.2之后直接在方法中使用@EventListener即可。

1. 定义事件
```java
public class UserCreateEvent extends ApplicationEvent {
    private User user;

    public UserCreateEvent(Object source, User user) {
        super(source);
        this.user = user;
    }

    public User getUser() {
        return user;
    }

    public void setUser(User user) {
        this.user = user;
    }
}
```

2. 定义监听者
```java
// 继承ApplicationListener方式创建监听者
@Component
public class UserCreateEventListener implements ApplicationListener<UserCreateEvent> {
    @Override
    public void onApplicationEvent(UserCreateEvent event) {
        System.out.println("UserCreateEvent 事件被触发。。。");
        System.out.println(event.getUser());
    }

    // 通过注解创建监听者
    @EventListener(classes = {UserCreateEvent.class}) //classes属性指定处理事件的类型
    @Async //异步监听
    @Order(0)//使用order指定顺序，越小优先级越高
    public void eventListener(UserCreateEvent event) {
        System.out.println("通过注解@EventListener和@Async,异步监听OrderCreateEvent事件,orderId:" + event.getUser());
    }
}
```

3. 调用事件
```java
public class SpringEventTest {
    @Test
    public void eventTest() {
        ApplicationContext applicationContext = new ClassPathXmlApplicationContext("application-bean.xml");
        // 调用事件
        applicationContext.publishEvent(new UserCreateEvent(this, new User("fish", 18, "male")));
    }
}
```

# 适配器模式
SpringMVC，SpringAOP使用适配器模式。

# 装饰者模式
作用：可以在不改变原有对象的情况下拓展其功能。

jdk中的IO，Spring中的DataSource
