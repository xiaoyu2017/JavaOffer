# 1. 核心配置文件

> 配置文件标签是需要按照指定顺序来设置的。

```xml
<?xml version="1.0" encoding="UTF-8" ?>
<!DOCTYPE configuration PUBLIC "-//mybatis.org//DTD Config 3.0//EN" "http://mybatis.org/dtd/mybatis-3-config.dtd">
<configuration>
    <!--
        引入外部配置文件：
            resource：被引用文件名称
    -->
    <properties resource="jdbc.properties"/>

    <!--mybatis的全局配置信息-->
    <settings>
        <!--是否开启驼峰命名自动映射（默认关闭）-->
        <setting name="mapUnderscoreToCamelCase" value="true"/>
    </settings>

    <!--
        类型别名，不需要直接使用全类名，
        别名不区分大小写
    -->
    <typeAliases>
        <!--
            单独设置单个别名:
                type:需要设置的类
                alias：可不写，不写默认为类名
        -->
        <typeAlias type="cn.fishland.bookmanager.bean.pojo.Ebook" alias="Ebook"/>
        <!--设置包下所有别名-->
        <package name="cn.fishland.bookmanager.bean"/>
    </typeAliases>

    <!--
        配置数据源：
            default：使用的环境
    -->
    <environments default="developement">
        <!--
            单独数据源配置：
                id：数据源唯一标识
        -->
        <environment id="developement">
            <!--设置事务类型，JDBC表示后当前数据库-->
            <transactionManager type="JDBC"/>
            <!--
                dataSource：表示数据源设置
                    type：表示数据源类型，是否使用连接池
                        POOLED：使用连接池
                        UNPOOLED：表示不使用连接池
                        JNDI：使用上下文数据源
            -->
            <dataSource type="POOLED">
                <!--
                    property：数据源相关配置
                        name：名称
                        value：值
                -->
                <property name="driver" value="${jdbc.driver}"/>
                <property name="url" value="${jdbc.url}"/>
                <property name="username" value="${jdbc.username}"/>
                <property name="password" value="${jdbc.password}"/>
            </dataSource>
        </environment>
    </environments>

    <!--加载映射文件-->
    <mappers>
        <!--mapper xml-->
        <mapper resource="cn/fishland/bookmanager/mapper/CategoryMapper.xml"/>
        <!--
            mapper interface class：以下条件为必须条件
                1. 需要mapper和接口目录结构相同，全类名相同
                2. mapper和接口类相同
        -->
        <package name="cn.fishland.bookmanager.mapper"/>
    </mappers>
</configuration>
```

# 2. 接口和mapper的xml文件映射

1. 映射文件的namespace和接口全类名称相同
2. 接口中的方法名和mapper中的id相同

```java
public interface UserMapper {
    int addUser(User user);
}
```

```xml
<?xml version="1.0" encoding="UTF-8" ?>
<!DOCTYPE mapper PUBLIC "-//mybatis.org//DTD Mapper 3.0//EN" "http://mybatis.org/dtd/mybatis-3-mapper.dtd">
<mapper namespace="cn.fishland.mapper.UserMapper">
    <insert id="addUser" parameterType="cn.fishland.bookmanager.bean.pojo.User">
        insert into category(`name`) value (#{name});
    </insert>
</mapper>
```

# 3. mapper查询

需要设置resultType或resultMap resultType：字段与数据库相同，直接使用bean resultMap：字段与数据库列不相同，需要单独处理

# 4. 获得参数值

1. `${}`:直接sql拼接
2. `#{}`:占位符拼接

## 4.1 传入单个字面量值

`User findById(Integer id)`

`${}`：需要添加双引号,值可以随便写，不受影响
`#{}`:值随便写，不受影响，占位符

```sql
select *
from user
where id = '${id}'；
select *
from user
where id = '1'；

select *
from user
where id = #{xxx}；
select *
from user
where id = '1'；
```

## 4.2 传入多个字面量值

`User findByPasswordAndName(String name, String password)`

`#{}`和`${}`：在获得多个值时，mybatis会自动将参数放在map集合中，两种方式存储，arg0，arg1...或param1,param2...两种方式都行，可混用

```sql
select *
from user
where name = #{arg0}
  and password = #{param2}
```

## 4.3 传入Map集合参数

`User findUserByMap(Map map)`

`#{}`和`${}`：在获得值时可以直接通过key获得值

```java
Map<String, String> map=new HashMap<>();
        map.put("name","fish");
        map.put("password","fish123");
```

```sql
select *
from user
where name = #{name}
  and password = #{password}
```

## 4.4 传入实体类对象

`User findUser(User user)`

与map参数相同，获得值只需要将`#{}`内部的值设置为属性值就可以了。通过get和set方法获得。

## 4.5 命名参数@Param

通过注解来指定参数名称

`User findUserByNameAndPassword(@Param("name")String name, @Param("password")String password)`

`#{}`和`${}`使用时直接将name和password放在大括号中即可。也可以使用param1，param2...来使用。

# 5. 返回值

## 5.1 返回多条记录

需要使用集合来接收

`List<User> getAllUser()`

## 5.2 聚合查询

统计数量

`int count()`

```xml

<select id="count" resultMap="int">
    select count(1) from user;
</select>
```

> 基础数据类型，mybatis提供了默认的类型别名

## 5.3 @Mapkey("字段名")

使用map直接接收多条信息，指定map的key

```java
@Mapkey("id")
Map<Integer, Object> getAllUser();
```

# 6. 模糊查询

1. 使用`${}`进行模糊查询

```sql
select *
from user
where name like '%${name}%'
```

2. 使用`#{}`加count()函数进行拼接

```sql
select *
from user
where name like concat('%', #{name}, '%');
```

3. 使用`#{}`加双引号函数进行拼接

```sql
select *
from user
where name like "%"#{name}"%";
```

# 6. 批量删除

> 使用in，将条件拼接后当参数传递sql中执行

`int deletes(@Param("ids")String ids)`

```sql
select *
from user
where id in (${ids})
```

**不能使用`#{}`只能使用`${}`这种才能进行删除，主要原因是`#{}`会自动添加引号**

# 7. 批量插入

```java
```



# 7. 新增获得自增主键

> 新增后将自增主键放在参数中返回

`void insertUser(User user)`

```xml
<!--
    useGeneratedKeys:设置sql是否使用自增主键
    keyProperty:将自增主键赋值到参数中的某个值或属性中
-->
<insert id="insertUser" parameterType="User" useGeneratedKeys="true" keyProperty="id">
    insert into user(`name`) value (#{name});
</insert>
```

# 8. 自定义映射

> 表中的列名和类属性值不相同，或者多表查询结果问题，这时就需要使用resultMap，结果映射来完成。

## 8.1 通过别名处理列和属性不相同问题

```xml
<!--解决类字段和表列不相同问题<别名加代码片段（只用别名s也可以）>-->
<sql id="userSql">
    id, createTime, updateTime, status, sort, nick_name as nickName, name, password, icon, email,
    company_name as companyName, sex, birthday, code, role
</sql>
        <!--处理类字段和表列不相同问题<resultMap>-->
<select id="selectById" resultType="User">
select
<include refid="userSql"/>
from user
where id = #{id}
and status = 1;
</select>
```

## 8.2 通过mapUnderscoreToCamelCase全局配置

```xml
<!--mybatis的全局配置信息-->
<settings>
    <!--是否开启驼峰命名自动映射（默认关闭）-->
    <setting name="mapUnderscoreToCamelCase" value="true"/>
</settings>
```

## 8.3 使用resultMap进行设置

```xml
<!--解决类字段和表列不相同问题<resultMap>-->
<resultMap id="userResult" type="User">
    <result property="companyName" column="company_name"/>
    <result property="nickName" column="nick_name"/>
</resultMap>

        <!--
            resultMap：返回映射唯一id
        -->
<select id="selectAll" resultMap="userResult">
select *
from user;
</select>
```

# 9 多表对应

准备内容：

```java
class Emp {
    private Integer id;
    private String empName;
    private Integer age;
    private String sex;
    private String email;
    private Dept dept;
    //...
}

class Dept {
    private Integer did;
    private String name;
    //...
}
```

## 9.1 多对一

1. 通过resultMap和级联属性来解决映射问题

```xml
<!--解决类字段和表列不相同问题<resultMap>-->
<resultMap id="empManyOne" type="Emp">
    <id property="id" column="id"/>
    <result property="empName" column="emp_name"/>
    <result property="age" column="age"/>
    <result property="sex" column="sex"/>
    <result property="email" column="email"/>
    <!--级联属性-->
    <result property="dept.did" column="did"/>
    <!--级联属性-->
    <result property="dept.name" column="name"/>
</resultMap>
        <!--
            resultMap：返回映射唯一id
        -->
<select id="selectAll" resultMap="empManyOne">
select * from emp e left join dept d on e.did = d.did where e.id = #{id};
</select>
```

2. 通过association属性来进行设置

```xml
<!--解决类字段和表列不相同问题<resultMap>-->
<resultMap id="empManyOne" type="Emp">
    <id property="id" column="id"/>
    <result property="empName" column="emp_name"/>
    <result property="age" column="age"/>
    <result property="sex" column="sex"/>
    <result property="email" column="email"/>
    <!--通过association来实现-->
    <association property="dept" javaType="Dept">
        <id property="did" column="did"/>
        <result property="name" column="name"/>
    </association>
</resultMap>
        <!--
            resultMap：返回映射唯一id
        -->
<select id="selectAll" resultMap="empManyOne">
select * from emp e left join dept d on e.did = d.did where e.id = #{id};
</select>
```

3. 分步查询

```xml

<mapper namespace="DeptMapper">
    <select id="findByDid" resultType="Dept">
        select * from dept where did = #{did}
    </select>
</mapper>
```

```xml
<!--解决类字段和表列不相同问题<resultMap>-->
<resultMap id="empManyOne" type="Emp">
    <id property="id" column="id"/>
    <result property="empName" column="emp_name"/>
    <result property="age" column="age"/>
    <result property="sex" column="sex"/>
    <result property="email" column="email"/>
    <!--
        通过association的分步查询来实现：
            select:关联的是查询的语句（mapper唯一表示）
            column：查询条件的咧，当前哪个列作为条件传递给下一查询
            fetchType：有效值为 lazy 和 eager。 指定属性后，将在映射中忽略全局配置参数 lazyLoadingEnabled，使用属性的值。
    -->
    <association property="dept" select="DeptMapper.findByDid" column="did" fetchType="lazy"/>
</resultMap>
        <!--
            resultMap：返回映射唯一id
        -->
<select id="selectAll" resultMap="empManyOne">
select * from emp where id = #{id};
</select>
```

**分布查询是可以懒加载，当不访问响应属性是不直接访问的。**
懒加载是需要全局配置的：

```xml
<!--mybatis的全局配置信息-->
<settings>
    <!--是否开启懒加载（开启懒加载要确保aggressiveLazyLoading属性为false）-->
    <setting name="lazyLoadingEnabled" value="true"/>
</settings>
```

## 9.2 一对多

准备内容：

```java
class Emp {
    private Integer id;
    private String empName;
    private Integer age;
    private String sex;
    private String email;
    //...
}

class Dept {
    private Integer did;
    private String name;
    private List<Emp> emps;
    //...
}
```

1. collection标签

```xml
<!--解决类字段和表列不相同问题<resultMap>-->
<resultMap id="deptManyOne" type="Dept">
    <id property="did" column="did"/>
    <result property="name" column="name"/>
    <collection property="emps" ofType="Emp">
        <id property="id" column="id"/>
        <result property="empName" column="emp_name"/>
        <result property="age" column="age"/>
        <result property="sex" column="sex"/>
        <result property="email" column="email"/>
    </collection>
</resultMap>
        <!--
            resultMap：返回映射唯一id
        -->
<select id="selectAll" resultMap="deptManyOne">
select * from dept d left join emp e on d.did = e.did where did = #{did};
</select>
```

2. collection分步查询

```xml

<mapper namespace="EmpMapper">
    <select id="getAllByDid" resultType="Emp">
        select * from emp where did = #{did}
    </select>
</mapper>
```

```xml
<!--解决类字段和表列不相同问题<resultMap>-->
<resultMap id="deptManyOne" type="Dept">
    <id property="did" column="did"/>
    <result property="name" column="name"/>
    <!--
        分布查询：也可以开启懒加载
    -->
    <collection property="emps" select="EmpMapper.getAllByDid" column="did"/>
</resultMap>
        <!--
            resultMap：返回映射唯一id
        -->
<select id="selectAll" resultMap="deptManyOne">
select * from dept where did = #{did};
</select>
```

# 10. 动态sql

> 动态多条件查询就可以使用以下标签来实现

## 10.1 if标签

```xml

<select id="findByCategory" resultType="Category">
    select * from category where 1 = 1
    <if test="name!=null and name!=''">
        `name` = #{name}
    </if>
    <if test="status!=null">
        `status` = #{status}
    </if>
</select>
```

## 10.2 where标签

> 当所有条件都不成立时，这时where关键字就多余，可以使用where来解决这一问题

```xml

<select id="findByCategory" resultType="Category">
    select * from category
    <where>
        <if test="name!=null and name!=''">
            `name` = #{name}
        </if>
        <if test="status!=null">
            and `status` = #{status}
        </if>
    </where>
</select>
```

**where标签只能把if标签中多余的and或or去掉，放在结尾的and或or是去不掉的**

## 10.3 trim标签

```xml
<!--
    prefix|suffix：将trim标签前|后添加指定内容
    prefixOverrides|suffixOverrides：将trim前后去掉指定内容
-->
<trim suffix="" prefix="" suffixOverrides="" prefixOverrides=""/>
```

```xml
<!--
    trim：标签内内容全部成立也不会有效果
-->
<select id="findByCategory" resultType="Category">
    select * from category
    <trim prefix="where" suffixOverrides="and|or">
        <if test="name!=null and name!=''">
            `name` = #{name} and
        </if>
        <if test="status!=null">
            `status` = #{status} or
        </if>
    </trim>
</select>
```

## 10.4 choose，when，otherwise

```xml
<!--
    类似于if...else if...else if...else...
    
    choose:表示整个结构
    when：类似elseif
    otherwise：表示都不成立需要执行内容
-->
<select id="findByCategory" resultType="Category">
    select * from category
    <where>
        <choose>
            <when test="name!=null and name!=''">
                `name` = #{name}
            </when>
            <when test="status!=null">
                `status` = #{status}
            </when>
            <otherwise>
                id = 1
            </otherwise>
        </choose>
    </where>
</select>
```

## 10.5 foreach

```xml
<!--
    foreach：循环（for）
        separator:分隔符
        open：以什么开头
        close：以什么结尾
-->
<delete id="deleteAll">
    delete from category where id in
    <foreach collection="ids" item="id" separator="," open="(" close=")">
        #{id}
    </foreach>
</delete>
```

## 10.6 sql标签

```xml

<sql id="categoryColumn">id,name,status,sort</sql>
<select id="findAll" resultType="Category">
select
<include refid="categoryColumn"/>
from category
</select>
```

# 11 缓存

> mybatis会把查询到的数据进行缓存，这样相同的查询无需数据库请求即可完成。

## 11.1 一级缓存

这是SqlSession层级的缓存默认开启，缓存是在一次sqlSession中存在的。相同SqlSession不同的mapper缓存也是共享的。

**一级缓存失效：**

- 使用不同的SqlSession
- 两次查询条件不同
- 两次查询之间进行增删改
- 两次查询间手动清理缓存

## 11.2 二级缓存

开启：

1. 确保cacheEnabled值为true（默认值），在全局设置中设置
2. 映射文件中添加cache标签
3. 二级缓存在SqlSession提交或关闭后生效
4. 查询结果实体类必须实现序列化接口

使二级缓存失效的情况：两次查询之间执行了任意的增删改，会使一级和二级缓存同时失效

## 11.3 二级缓存设置

- 在mapper配置文件中添加的cache标签可以设置一些属性
- eviction属性：缓存回收策略
    - LRU（Least Recently Used） – 最近最少使用的：移除最长时间不被使用的对象。
    - FIFO（First in First out） – 先进先出：按对象进入缓存的顺序来移除它们。
    - SOFT – 软引用：移除基于垃圾回收器状态和软引用规则的对象。
    - WEAK – 弱引用：更积极地移除基于垃圾收集器状态和弱引用规则的对象。
    - 默认的是 LRU
- flushInterval属性：刷新间隔，单位毫秒
    - 默认情况是不设置，也就是没有刷新间隔，缓存仅仅调用语句（增删改）时刷新
- size属性：引用数目，正整数
    - 代表缓存最多可以存储多少个对象，太大容易导致内存溢出
- readOnly属性：只读，true/false
    - true：只读缓存；会给所有调用者返回缓存对象的相同实例。因此这些对象不能被修改。这提供了很重要的性能优势。
    - false：读写缓存；会返回缓存对象的拷贝（通过序列化）。这会慢一些，但是安全，因此默认是false

## 11.4 MyBatis缓存查询的顺序

- 先查询二级缓存，因为二级缓存中可能会有其他程序已经查出来的数据，可以拿来直接使用
- 如果二级缓存没有命中，再查询一级缓存
- 如果一级缓存也没有命中，则查询数据库
- SqlSession关闭之后，一级缓存中的数据会写入二级缓存

# 12. 分页插件

1. 添加插件

```xml
<!--分页插件-->
<dependency>
    <groupId>com.github.pagehelper</groupId>
    <artifactId>pagehelper</artifactId>
    <version>5.3.2</version>
</dependency>
```

2. 核心配置文件配置

```xml
<!--添加插件-->
<plugins>
    <!--分页插件-->
    <plugin interceptor="com.github.pagehelper.PageInterceptor"/>
</plugins>
```

3. 3种简单实现

```java
@Test
public void testCategoryPage1(){
        PageHelper.startPage(1,3);
        List<Object> list=sqlSession.selectList("categoryMapper.findAll");
        System.out.println(list);
        }

@Test
public void testCategoryPage2(){
        Page<Object> page=PageHelper.startPage(1,4);
        List<Object> list=sqlSession.selectList("categoryMapper.findAll");
        System.out.println(page);
        System.out.println(list);
        }

@Test
public void testCategoryPage3(){
        PageHelper.startPage(1,4);
        List<Category> list=sqlSession.selectList("categoryMapper.findAll");
        PageInfo<Category> page=new PageInfo<>(list,5);
        System.out.println(page);
        }
```

Page和PageInfo相关属性：

- list：分页之后的数据
- pageNum：当前页的页码
- pageSize：每页显示的条数
- size：当前页显示的真实条数
- total：总记录数
- pages：总页数
- prePage：上一页的页码
- nextPage：下一页的页码
- isFirstPage/isLastPage：是否为第一页/最后一页
- hasPreviousPage/hasNextPage：是否存在上一页/下一页
- navigatePages：导航分页的页码数
- navigatepageNums：导航分页的页码，[1,2,3,4,5]

# 13. 注解开发

> 注解只适合简单的语句，并不适合复杂语句，使本就复杂的sql更复杂。使用注解开发不需要再创建Mapper配置文件。

> 主要的注解`@Select、@Insert、@Delete，@Update`

## 13.1 简单实用

```java
public interface MenuMapper {
    @Insert("insert into menu(`name`, `icon`, `link`, `parent`, `sort`, `status`) " +
            "value (#{name}, #{icon}, #{link}, #{parent}, #{sort}, #{status});")
    int insert(Menu menu);

    @Insert("delete from menu where id = #{id}")
    int delete(@Param("id") long id);

    @Update("update menu set name = #{name}, icon = #{icon}, link = #{link}, sort = #{sort} where id = #{id}")
    int update(Menu menu);

    @Select("select * from menu where id = #{id}")
    Menu select(@Param("id") long id);
}
```

## 13.2 @Result、@Result、@One、@Many

> `@Result`是来替换`<resultMap>`，`@Result`替换标签`<result>`，`@One`替换标签`<association>`，`@Many`替换标签`<collection>`

@Result属性：

- column:数据库列名
- property：属性名
- one|many：`@One|@Many`

### 13.2.1 一对一

```java
public interface OrderMapper {

    @Results({
            @Result(property = "id", column = "id"),
            @Result(property = "orderTime", column = "orderTime"),
            @Result(property = "total", column = "total"),
            @Result(property = "user", column = "uid", javaType = User.class,
                    one = @One(select = "UserMapper.findById"))
    })
    @Select("select * from order")
    List<Order> findAll();
}

public interface UserMapper {

    @Select("select * from user where id = #{id}")
    List<Order> findById(Integer id);
}
```

### 13.2.2 一对多

```java
public interface UserMapper {

    @Results({
            @Result(property = "id", column = "id"),
            @Result(property = "name", column = "name"),
            @Result(property = "sex", column = "sex"),
            @Result(property = "order", column = "id", javaType = List.class,
                    many = @Many(select = "OrderMapper.findById"))
    })
    @Select("select * from order")
    List<User> findAll();
}

public interface OrderMapper {

    @Select("select * from order where id = #{id}")
    List<Order> findById(Integer id);
}
```

### 13.2.3 多对多

> 和一对多很类似，只不过一对多返回的结果是单行数据，多对多返回的是集合。

## 13.3 注解配置属性

### 13.3.1 插入数据并为插入对象赋值插入结果值

```java
public interface UserDao {
    @Options(useGeneratedKeys = true, keyProperty = "id", keyColumn = "id")
    @Insert("INSERT INTO user (name, age, email, birthday) VALUES(#{name}, #{age}, #{email}, #{birthday})")
    int insert(User user);
}
```