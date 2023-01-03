> 相关基础语法可以参考[Java菜鸟教程](https://www.runoob.com/java/java-tutorial.html)

# 1. NaN

在Java中是有float和double实现了这个规范，即除数为0时结果为NaN。

`0.0f / 0.0f = NaN` NaN值比较特殊，它不会等于任何值，包括他自己。

所以在Float和Double都有isNaN静态方法，源代码比较简单，示例如下：

```java
public static boolean isNaN(float v) {
    return (v != v);
}
```

# 2. 隐式类型转换
```java
short x = 1; s = s + 1; // 运行错误
short x = 1; s += 1; // 运行正确，隐式类型转换
// +=会隐式类型转换
```

# 3. 关键字

|关键字|修饰类|修饰方法|修饰属性|
|---|---|---|---|
|final|最终类，不可被继承|最终方法，不可被重写|常量，初始化后不可修改|
|||||
|||||
|||||
|||||

# 4. 常见方法

## 4.1 Math

1. Math.round(f):向上取最小整数，大小值取值范围为Long范围。

# 5. 类、抽象类、接口

|比较|类|抽象类|接口|
|---|---|---|---|
|使用final修饰|可以|不可以|不可以|
|含抽象方法|不可以|可以|可以|
|实例化|可以|不可以|不可以|
|类继承/实现|extends 唯一|extends 唯一|implements 多个|
|接口继承/实现|不可以|不可以|extends 多个

# 6. JDBC问题

## 6.1 基础使用步骤

执行步骤：
1. 加载驱动
2. 建立连接
3. 执行sql
4. 处理返回结果
5. 释放资源

## 6.2 sql注入问题

问题简介：
用户登录判断sql`select * from user where user='"+username+"' and password='"+password+"';`

sql注入变量赋值`username="' or 1 = 1 -"`

这样就会导致不管密码对不对都会登录成功，最后的sql变成如下：
`select * from user where user='' or 1=1 - and password='*******'`

问题解决办法：
使用`PreparedStatement`类来预编译sql语句。

# 7. final、finalize、finally比较
final：关键字，表示最终的。
finalize：方法，定义在Object中，jvm回收类时调用。
finally：代码块，与try代码块一起用，无论如何最终都会执行。

# 8. 运算符

|运算符|示例|说明|
|----|----|----|
|&|3&8=0|按位与，都为1结果为1，否则都为0|
|&&|布尔表达式1 && 布尔表达式2|短路与逻辑运算符，两端只能是布尔结果，布尔表达式1不成立将不再执行布尔表达式2|
||||
||||

# 9. 重载和重写

重载：除方法名相同，其他都可不同，参数必须不同。
重写：方法名和参数必须相同，返回值可以是本身及其父类，异常可以是本身及其子类。

# 10. 继承

子类不能继承父类私有属性和构造方法。

# 11. 拆箱和装箱

装箱：将基本类型转换成对应的引用类型。`Interger i = 10;`。类似1.5前的`Integer i = Integer.valueOf(10);`。

拆箱：将引用类型转换成对应的基本数据类型。`int a = 1;`。类似1.5前`int a = i.intValue();`。

byte    short   int      long    float    double    boolean     char
Byte    Short   Integer  Long    Float    Double    Boolean     Character

# 12. 类、方法、成员变量和局部变量可使用修饰符

<table>
    <tr>
        <td>位置</td>
        <td>关键字</td>
        <td>说明</td>
    </tr>
    <tr>
        <td rowspan="3">类</td>
        <td>public</td>
        <td>可以从其他类中访问</td>
    </tr>
    <tr>
        <td>Abstract</td>
        <td>抽象类，不能被实例化，可包含抽方法</td>
    </tr>
    <tr>
        <td>final</td>
        <td>最终类，不能被继承</td>
    </tr>
    <tr>
        <td rowspan="3">构造方法</td>
        <td>public</td>
        <td>所有类可以调用</td>
    </tr>
    <tr>
        <td>protected</td>
        <td>本类及其子类</td>
    </tr>
    <tr>
        <td>private</td>
        <td>仅自己</td>
    </tr>
    <tr>
        <td rowspan="8">成员方法</td>
        <td>public</td>
        <td>所有类可以调用</td>
    </tr>
    <tr>
        <td>protected</td>
        <td>本类及其子类</td>
    </tr>
    <tr>
        <td>private</td>
        <td>仅本类访问</td>
    </tr>
    <tr>
        <td>abstract</td>
        <td>抽象方法，没有方法体</td>
    </tr>
    <tr>
        <td>final</td>
        <td>子类不能重写</td>
    </tr>
    <tr>
        <td>static</td>
        <td>被绑定于类本身而不是类的实例</td>
    </tr>
    <tr>
        <td>native</td>
        <td>该方法由其他编程语言实现</td>
    </tr>
    <tr>
        <td>synchronized</td>
        <td>在一个线程调用它之前必须先给它加</td>
    </tr>
    <tr>
        <td rowspan="7">成员变量</td>
        <td>public</td>
        <td>所有类可以调用</td>
    </tr>
    <tr>
        <td>protected</td>
        <td>本类及其子类</td>
    </tr>
    <tr>
        <td>private</td>
        <td>仅本类访问</td>
    </tr>
    <tr>
        <td>static</td>
        <td>成员变量为类不为任何一个实例</td>
    </tr>
    <tr>
        <td>transient</td>
        <td>不序列化字段</td>
    </tr>
    <tr>
        <td>volatile</td>
        <td>多线程变量可见</td>
    </tr>
    <tr>
        <td>final</td>
        <td>一经赋值，不可修改</td>
    </tr>
    <tr>
        <td rowspan="7">局部变量</td>
        <td>final</td>
        <td>常量</td>
    </tr>
</table>


# 13. 静态方法、非静态方法

静态方法不可以调用非静态方法。
















