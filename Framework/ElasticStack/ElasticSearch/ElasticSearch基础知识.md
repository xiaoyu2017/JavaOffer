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

添加依赖：
```xml
<dependency>
    <groupId>org.elasticsearch.client</groupId>
    <artifactId>elasticsearch-rest-high-level-client</artifactId>
</dependency>
```

## 4.1 RestClient索引库操作

### 4.1.1 创建索引库

```java

@Slf4j
public class ElasticRestTest {

  String index = "{" +
          "  \"mappings\": {" +
          "    \"properties\": {" +
          "      \"id\": {" +
          "        \"type\": \"keyword\"" +
          "      }," +
          "      \"name\":{" +
          "        \"type\": \"text\"," +
          "        \"analyzer\": \"ik_max_word\"," +
          "        \"copy_to\": \"all\"" +
          "      }," +
          "      \"address\":{" +
          "        \"type\": \"keyword\"," +
          "        \"index\": false" +
          "      }," +
          "      \"price\":{" +
          "        \"type\": \"integer\"" +
          "      }," +
          "      \"score\":{" +
          "        \"type\": \"integer\"" +
          "      }," +
          "      \"brand\":{" +
          "        \"type\": \"keyword\"," +
          "        \"copy_to\": \"all\"" +
          "      }," +
          "      \"city\":{" +
          "        \"type\": \"keyword\"," +
          "        \"copy_to\": \"all\"" +
          "      }," +
          "      \"all\":{" +
          "        \"type\": \"text\"," +
          "        \"analyzer\": \"ik_max_word\"" +
          "      }" +
          "    }" +
          "  }" +
          "}";

  private RestHighLevelClient client;

  @BeforeEach
  void setUp() {
    this.client = new RestHighLevelClient(RestClient.builder(
            HttpHost.create("http://127.0.0.1:9200")
    ));
  }

  @AfterEach
  void tearDown() throws IOException {
    this.client.close();
  }

  // 创建索引库
  @Test
  void createHotelIndex() throws IOException {
    // 1.创建Request对象
    CreateIndexRequest request = new CreateIndexRequest("mall");
    // 2.准备请求的参数：DSL语句
    request.source(index, XContentType.JSON);
    // 3.发送请求
    client.indices().create(request, RequestOptions.DEFAULT);
  }
}
```

### 4.1.2 删除索引库

```java

public class ElasticRestTest {
    private RestHighLevelClient client;

    @BeforeEach
    void setUp() {
        this.client = new RestHighLevelClient(RestClient.builder(
                HttpHost.create("http://127.0.0.1:9200")
        ));
    }

    @AfterEach
    void tearDown() throws IOException {
        this.client.close();
    }

    // 删除索引
    @Test
    void testDeleteHotelIndex() throws IOException {
        // 1.创建Request对象
        DeleteIndexRequest request = new DeleteIndexRequest("mall");
        // 2.发送请求
        client.indices().delete(request, RequestOptions.DEFAULT);
    }
}

```

### 4.1.3 判断索引库是否

```java
public class ElasticRestTest {
  private RestHighLevelClient client;

  @BeforeEach
  void setUp() {
    this.client = new RestHighLevelClient(RestClient.builder(
            HttpHost.create("http://127.0.0.1:9200")
    ));
  }

  @AfterEach
  void tearDown() throws IOException {
    this.client.close();
  }

  // 判断索引库是否存在
  @Test
  void testExistsHotelIndex() throws IOException {
    // 1.创建Request对象
    GetIndexRequest request = new GetIndexRequest("mall");
    // 2.发送请求
    boolean exists = client.indices().exists(request, RequestOptions.DEFAULT);
    // 3.输出
    System.err.println(exists ? "索引库已经存在！" : "索引库不存在！");
  }
}
```

## 4.2 RestClient操作文档

### 4.2.1 新增文档

```java
public class SearchDocClientTest {
    private RestHighLevelClient client;

    @BeforeEach
    void setUp() {
        this.client = new RestHighLevelClient(RestClient.builder(
                HttpHost.create("http://127.0.0.1:9200")
        ));
    }

    @AfterEach
    void tearDown() throws IOException {
        this.client.close();
    }

    // 新增doc
    @Test
    void testAddDocument() throws IOException {
        // 1.根据id查询酒店数据
        Hotel hotel = new Hotel();
        hotel.setId(1234);
        hotel.setAddress("上海市浦东新区");
        hotel.setName("如家豪华酒店");
        hotel.setCity("上海");
        hotel.setBrand("如家");
        hotel.setPrice(589d);
        hotel.setScore(8);

        // 3.将Hotel转json
        String json = new ObjectMapper().writeValueAsString(hotel);

        // 1.准备Request对象
        IndexRequest request = new IndexRequest("mall").id(hotel.getId().toString());
        // 2.准备Json文档
        request.source(json, XContentType.JSON);
        // 3.发送请求
        client.index(request, RequestOptions.DEFAULT);
    }

}
```

### 4.2.2 查询文档

```java
public class SearchDocClientTest {
    private RestHighLevelClient client;

    @BeforeEach
    void setUp() {
        this.client = new RestHighLevelClient(RestClient.builder(
                HttpHost.create("http://127.0.0.1:9200")
        ));
    }

    @AfterEach
    void tearDown() throws IOException {
        this.client.close();
    }

    @Test
    public void getDoc() throws IOException {
        GetRequest getRequest = new GetRequest("mall","1234");

        GetResponse documentFields = client.get(getRequest, RequestOptions.DEFAULT);

        String sourceAsString = documentFields.getSourceAsString();

        Hotel hotel = new ObjectMapper().readValue(sourceAsString, Hotel.class);

        System.out.println(hotel);
    }

}

```

### 4.2.3 删除文档

```java
public class SearchDocClientTest {
    private RestHighLevelClient client;

    @BeforeEach
    void setUp() {
        this.client = new RestHighLevelClient(RestClient.builder(
                HttpHost.create("http://127.0.0.1:9200")
        ));
    }

    @AfterEach
    void tearDown() throws IOException {
        this.client.close();
    }

    @Test
    public void deleteDoc() throws IOException {
        DeleteRequest deleteRequest = new DeleteRequest("mall", "1234");

        DeleteResponse delete = client.delete(deleteRequest, RequestOptions.DEFAULT);

        System.out.println(delete.status());
    }

}
```


### 4.2.4 修改文档

全量修改和新增修改只有一个API，是根据id进行判断的。

```java
public class SearchDocClientTest {
    private RestHighLevelClient client;

    @BeforeEach
    void setUp() {
        this.client = new RestHighLevelClient(RestClient.builder(
                HttpHost.create("http://127.0.0.1:9200")
        ));
    }

    @AfterEach
    void tearDown() throws IOException {
        this.client.close();
    }

    @Test
    public void updateDoc() throws IOException {
        UpdateRequest update = new UpdateRequest("mall", "1234");

        update.doc(
                "price", 399.9
        );

        UpdateResponse response = client.update(update, RequestOptions.DEFAULT);

        System.out.println(response.status());
    }
}
```

## 4.3 批量操作文档

### 4.3.1 批量新增

```java
public class SearchDocClientTest {
    private RestHighLevelClient client;

    @BeforeEach
    void setUp() {
        this.client = new RestHighLevelClient(RestClient.builder(
                HttpHost.create("http://127.0.0.1:9200")
        ));
    }

    @AfterEach
    void tearDown() throws IOException {
        this.client.close();
    }

    @Test
    public void bulkAddDoc() throws IOException {
        List<Hotel> list = new ArrayList<>();
        for (int i = 0; i < 10; i++) {
            Hotel hotel = new Hotel();
            hotel.setId(1 + i);
            hotel.setAddress("上海市浦东新区" + i);
            hotel.setName("如家豪华酒店" + i);
            hotel.setCity("上海" + i);
            hotel.setBrand("如家" + i);
            hotel.setPrice(589.9d + i);
            hotel.setScore(i);
            list.add(hotel);
        }

        BulkRequest bulkRequest = new BulkRequest();

        ObjectMapper objectMapper = new ObjectMapper();

        for (Hotel hotel : list) {
            bulkRequest.add(
                    new IndexRequest("mall")
                            .id(hotel.getId().toString())
                            .source(objectMapper.writeValueAsString(hotel), XContentType.JSON)
            );
        }

        client.bulk(bulkRequest, RequestOptions.DEFAULT);
    }
}

```

### 4.3.2 批量修改

```java
public class SearchDocClientTest {
  private RestHighLevelClient client;

  @BeforeEach
  void setUp() {
    this.client = new RestHighLevelClient(RestClient.builder(
            HttpHost.create("http://127.0.0.1:9200")
    ));
  }

  @AfterEach
  void tearDown() throws IOException {
    this.client.close();
  }

  @Test
  public void bulkUpdateDoc() throws IOException {
    List<Hotel> list = new ArrayList<>();
    for (int i = 0; i < 10; i++) {
      Hotel hotel = new Hotel();
      hotel.setId(1 + i);
      hotel.setPrice(299.9d + i);
      list.add(hotel);
    }

    BulkRequest bulkRequest = new BulkRequest();

    for (Hotel hotel : list) {
      bulkRequest.add(
              new UpdateRequest("mall", hotel.getId().toString())
                      .doc(
                              "price", hotel.getPrice()
                      )
      );
    }
    client.bulk(bulkRequest, RequestOptions.DEFAULT);
  }
}
```

### 4.3.3 批量删除

```java
public class SearchDocClientTest {
  private RestHighLevelClient client;

  @BeforeEach
  void setUp() {
    this.client = new RestHighLevelClient(RestClient.builder(
            HttpHost.create("http://127.0.0.1:9200")
    ));
  }

  @AfterEach
  void tearDown() throws IOException {
    this.client.close();
  }

  @Test
  public void bulkDeleteDoc() throws IOException {
    List<Hotel> list = new ArrayList<>();
    for (int i = 0; i < 10; i++) {
      Hotel hotel = new Hotel();
      hotel.setId(1 + i);
      hotel.setPrice(299.9d + i);
      list.add(hotel);
    }

    BulkRequest bulkRequest = new BulkRequest();

    for (Hotel hotel : list) {
      bulkRequest.add(
              new DeleteRequest("mall").id(hotel.getId().toString())
      );
    }

    client.bulk(bulkRequest, RequestOptions.DEFAULT);
  }
}
```

# 5. DSL查询

常见查询类型：

- **查询所有**：查询出所有数据，一般测试用。例如：match_all
- **全文检索（full text）查询**：利用分词器对用户输入内容分词，然后去倒排索引库中匹配。例如：
  - match_query
  - multi_match_query
- **精确查询**：根据精确词条值查找数据，一般是查找keyword、数值、日期、boolean等类型字段。例如：
  - ids
  - range
  - term
- **地理（geo）查询**：根据经纬度查询。例如：
  - geo_distance
  - geo_bounding_box
- **复合（compound）查询**：复合查询可以将上述各种查询条件组合起来，合并查询条件。例如：
  - bool
  - function_score


基本查询语法：

```json
GET /indexName/_search
{
  "query": {
    "查询类型": {
      "查询条件": "条件值"
    }
  }
}
```

查询所有：无需参数
```json
// 查询所有
GET /mall/_search
{
  "query": {
    "match_all": {}
  }
}
```

## 5.1 全文检索查询

> 根据用户输入内容，进行分层，然后查询内容。所有被查询字段是可以分词的类型Text


基本语法：

- match：单字段查询
- multi_match：多字段查询，任意一个字段符合条件就算符合查询条件

match：
```json
GET /indexName/_search
{
  "query": {
    "match": {
      "FIELD": "TEXT"
    }
  }
}
```

multi_match:
```json
GET /indexName/_search
{
  "query": {
    "multi_match": {
      "query": "TEXT",
      "fields": ["FIELD1", " FIELD12"]
    }
  }
}
```












