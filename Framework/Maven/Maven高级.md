# 1. 分模块开发

> 将一个大型项目分解成多个小项目，进行单独维护

![](../../img/maven6.png)

# 2. 聚合

> 多模块由单独一个项目管理，防止未能及时更新修改，这就叫聚合。此项目没有任何功能，只做模块管理。

创建管理项目：

创建一个项目，只保留pom文件：

```xml
<?xml version="1.0" encoding="UTF-8"?>
<project xmlns="http://maven.apache.org/POM/4.0.0"
         xmlns:xsi="http://www.w3.org/2001/XMLSchema-instance"
         xsi:schemaLocation="http://maven.apache.org/POM/4.0.0 http://maven.apache.org/xsd/maven-4.0.0.xsd">
    <modelVersion>4.0.0</modelVersion>

    <groupId>cn.fishland</groupId>
    <artifactId>ssm</artifactId>
    <version>1.0-SNAPSHOT</version>

    <!--表示此项目为一个管理项目-->
    <packaging>pom</packaging>

    <!--管理列表-->
    <modules>
        <module>../ssm_controller</module>
        <module>../ssm_dao</module>
        <module>../ssm_pojo</module>
        <module>../ssm_service</module>
    </modules>

</project>
```

# 3. 继承

> 建立模块中继承关系，父类统一管理子类依赖，子类继承父类依赖配置。

![](../../img/maven7.png)

创建步骤：
1. 在父模块pom文件中添加配置
```xml
<!--声明依赖管理-->
<dependencyManagement>
    <!--依赖类配-->
    <dependencies>
        <!--具体依赖-->
        <dependency>
            <groupId>org.springframework</groupId>
            <artifactId>spring-context</artifactId>
            <version>5.1.9.RELEASE</version>
        </dependency>
    <dependencies>
<dependencyManagement>
```
2. 在子模块中添加配置
```xml
<!--继承的模块-->
<parent>
    <groupId>com.itheima</groupId>
    <artifactId>ssm</artifactId>
    <version>1.0-SNAPSHOT</version>
    <!--父工程pom文件路径 -->
    <relativePath>../ssm/pom.xml</relativePath>
</parent>
```

3. 子模块依赖使用
```xml
<dependencies>
    <dependency>
        <groupId>org.springframework</groupId>
        <artifactId>spring-context</artifactId>
    </dependency>
</dependencies>
```
