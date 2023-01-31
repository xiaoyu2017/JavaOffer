# 1. 概述

> elasticsearch是一款非常强大的开源搜索引擎，具备非常多强大功能，可以帮助我们从海量数据中快速找到需要的内容

倒排索引概念。

与Mysqlg概念相比：

| **MySQL** | **Elasticsearch** | **说明**                                                     |
| --------- | ----------------- | ------------------------------------------------------------ |
| Table     | Index             | 索引(index)，就是文档的集合，类似数据库的表(table)           |
| Row       | Document          | 文档（Document），就是一条条的数据，类似数据库中的行（Row），文档都是JSON格式 |
| Column    | Field             | 字段（Field），就是JSON文档中的字段，类似数据库中的列（Column） |
| Schema    | Mapping           | Mapping（映射）是索引中文档的约束，例如字段类型约束。类似数据库的表结构（Schema） |
| SQL       | DSL               | DSL是elasticsearch提供的JSON风格的请求语句，用来操作elasticsearch，实现CRUD |

# 2. 安装

见CSDN博客：[安装ES和Kibana](https://blog.csdn.net/boling_cavalry/article/details/125196035)

# 3. 数据定义操作

## 3.1 索引库操作

> 索引库就类似数据库表，mapping映射就类似表的结构。

### 3.1.2 mapping

> 类似数据库的约束，或者说是类型也可以。

- type：字段数据类型，常见的简单类型有：
    - 字符串：text（可分词的文本）、keyword（精确值，例如：品牌、国家、ip地址）
    - 数值：long、integer、short、byte、double、float、
    - 布尔：boolean
    - 日期：date
    - 对象：object
- index：是否创建索引，默认为true
- analyzer：使用哪种分词器
- properties：该字段的子字段

### 3.1.2 索引库CRUD

#### 3.1.2.1 创建索引库

> 类似Mysql一样，创建表需要通过描述文本加一些类型和约束等。

**基本语法：**

- 请求方式：PUT
- 请求路径：/索引库名，可以自定义
- 请求参数：mapping映射

```json
/*格式*/
PUT /索引库名称
{
  "mappings": {
    "properties": {
      "字段名": {
        "type": "text",
        "analyzer": "ik_smart"
      },
      "字段名2": {
        "type": "keyword",
        "index": "false"
      },
      "字段名3": {
        "properties": {
          "子字段": {
            "type": "keyword"
          }
        }
      }
    }
  }
}
```

```json
/*示例*/
PUT /mall
{
  "mappings": {
    "properties": {
      "info": {
        "type": "text",
        "analyzer": "ik_smart"
      },
      "age": {
        "type": "int"
      },
      "email": {
        "type": "keyword",
        "index": "false"
      },
      "name": {
        "properties": {
          "firstName": {
            "type": "keyword"
          },
          "lastName": {
            "type": "keyword"
          }
        }
      }
    }
  }
}
```

#### 3.1.2.2 查询索引库

**基本语法**：

- 请求方式：GET
- 请求路径：/索引库名
- 请求参数：无

示例：`GET /mall`

#### 3.1.2.3 修改索引库

> 索引库一旦创建就不能修改，所以一般不会修改。但是可以添加mapping。

语法：

```json
PUT /索引库名/_mapping
{
  "properties": {
    "新字段名": {
      "type": "integer"
    }
  }
}
```

示例：

```json
put /mall/_mapping
{
  "properties": {
    "sex": {
      "type": "text"
    }
  }
}
```

#### 3.1.2.4 删除索引库

**语法：**

- 请求方式：DELETE
- 请求路径：/索引库名
- 请求参数：无

示例：`DELETE /mall`

## 3.2 文档操作

### 3.2.1 新增文档

```json
POST /索引库名/_doc/文档id
{
  "字段1": "值1",
  "字段2": "值2",
  "字段3": {
    "子属性1": "值3",
    "子属性2": "值4"
  }
  // ...
}
```
示例：
```json
POST /mall/_doc/1
{
  "sex":"wman",
  "age":18,
  "email":"wmanfish@email.com",
  "info":"CEO",
  "name":{
    "firstName":"fish",
    "lastName":"stack"
  }
}
```

### 3.2.2 查询文档

语法：`GET /{索引库名称}/_doc/{id}`

示例：`GET /mall/_doc/1`


### 3.2.3 修改文档

#### 3.2.3.1 全量修改文档

```json
PUT /{索引库名}/_doc/文档id
{
    "字段1": "值1",
    "字段2": "值2",
    // ... 略
}
```

示例：
```json
PUT /mall/_doc/1
{
  "sex":"wman",
  "age":20,
  "email":"fish@email.com",
  "info":"CEO",
  "name":{
    "firstName":"fish1",
    "lastName":"stack2"
  }
}
```

> 存在即修改，不存在就新增

#### 3.2.3.1 增量修改文档

> 只修改部分字段
语法
```json
POST /{索引库名}/_update/文档id
{
    "doc": {
         "字段名": "新的值",
    }
}
```

```json
POST /mall/_update/1
{
  "doc": {
    "age": 28
  }
}
```

### 3.2.4 删除文档

语法：`DELETE /{索引库名}/_doc/id值`

示例：`DELETE /mall/_doc/1`


# 4. RestApi

> es官网提供了各种语言的客户端

[官网文档](https://www.elastic.co/guide/en/elasticsearch/client/index.html)
















