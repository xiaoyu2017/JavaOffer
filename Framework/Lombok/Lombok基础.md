# 1. 简介

> 主要用于优化实体类中构造方法、get方法、set方法、toString、hashCode和equals。无需生产注解自动生成。

# 2. 入门

> IDEA可能保存，需要安装lombok插件。

1.添加依赖

```xml

<dependency>
    <groupId>org.projectlombok</groupId>
    <artifactId>lombok</artifactId>
    <version>1.18.12</version>
</dependency>
```

2.使用

```java

@Data
@AllArgsConstructor
@NoArgsConstructor
public class User {

    private Long id;
    private String name;
    private Integer age;
    private String email;
    private Date birthday;

}
```

> 如果需要自定义构造方法，可以直接在类中创建，不会受到影响。

# 3. 常用注解

- @Setter:为模型类的属性提供setter方法
- @Getter:为模型类的属性提供getter方法
- @ToString:为模型类的属性提供toString方法
- @EqualsAndHashCode:为模型类的属性提供equals和hashcode方法
- @Data:是个组合注解，包含上面的注解的功能
- @NoArgsConstructor:提供一个无参构造函数
- @AllArgsConstructor:提供一个包含所有参数的构造函数














