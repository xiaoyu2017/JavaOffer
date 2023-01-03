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
public interface UserMapper{
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
需要设置resultType或resultMap
resultType：字段与数据库相同，直接使用bean
resultMap：字段与数据库列不相同，需要单独处理

# 4. 获得参数值
1. `${}`:直接sql拼接
2. `#{}`:占位符拼接

## 4.1 传入单个字面量值

`User findById(Integer id)`


`${}`：需要添加双引号,值可以随便写，不受影响
`#{}`:值随便写，不受影响，占位符

```sql
select * from user where id = '${id}'；
select * from user where id = '1'；

select * from user where id = #{xxx}；
select * from user where id = '1'；
```

## 4.2 传入多个字面量值

`User findByPasswordAndName(String name, String password)`

`#{}`和`${}`：在获得多个值时，mybatis会自动将参数放在map集合中，两种方式存储，arg0，arg1...或param1,param2...两种方式都行，可混用

```sql
select * from user where name = #{arg0} and password = #{param2}
```

## 4.3 传入Map集合参数

`User findUserByMap(Map map)`

`#{}`和`${}`：在获得值时可以直接通过key获得值

```java
Map<String, String> map = new HashMap<>();
map.put("name","fish");
map.put("password","fish123");
```

```sql
select * from user where name = #{name} and password = #{password}
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
Map<Integer,Object> getAllUser();
```

# 6. 模糊查询
1. 使用`${}`进行模糊查询

```sql
select * from user where name like '%${name}%'
```

2. 使用`#{}`加count()函数进行拼接
```sql
select * from user where name like concat('%',#{name},'%');
```

3.  使用`#{}`加双引号函数进行拼接
```sql
select * from user where name like "%"#{name}"%";
```


# 6. 批量删除
> 使用in，将条件拼接后当参数传递sql中执行

`int deletes(@Param("ides")String ids)`

```sql
select * from user where id in (${ids})
```

**不能使用`#{}`只能使用`${}`这种才能进行删除，主要原因是`#{}`会自动添加引号**



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

class Dept{
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
    <id property="id" column="id" />
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
    <id property="id" column="id" />
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
    <id property="id" column="id" />
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

class Dept{
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
    <id property="did" column="did" />
    <result property="name" column="name"/>
    <collection property="emps" ofType="Emp">
        <id property="id" column="id" />
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
    <id property="did" column="did" />
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













