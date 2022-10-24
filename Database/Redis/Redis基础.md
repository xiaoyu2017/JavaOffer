[TOC]

# Redis
redis处理网络请求使用的是单线程模型和IO多路复用技术。持久化等使用的就是多线程。
> 单线程模型采用了IO多路复用计算，同时监控多个Socket，当发现待处理文件时，通过文件事件分派器分发到指定的事件处理器。

单线程效率较高原因：

  - 纯内存操作
  - 核心基于IO多路复用技术
  - 单线程避免多线程上下文内容切换

# 数据结构

## String
- 简介

Redis字符串并没有使用C语言字符串，而是自己构建了一种简单动态字符串（SDS）。相较C原字符串，SDS不但可以存文本内容也可以存二进制内容。

- 常用命令
  - SET key val：设置键和值。
  - SETNX key val：设置键和值，当key不存在时。
  - SETEX key seconds val：设置键、值和过期时间。
  - GET key：获得指定key值。
  - MSET key1 val1 key2 val2...：设置多个键和值。
  - MGET key1 key2...：获得多个key。
  - STRLEN key：获得val字符串长度。
  - INCR key：将key的值加一。
  - DECR key：将key的值减一。
  - EXISTS key：判断指定key是否存在。

- 使用场景
  - 储存常规数据：缓冲session，token，图片地址，序列化的后的对象。
  - 计数场景：资源单位时间访问次数。
  - 分布式锁

## List
- 简介

C语言没有链表数据结构，Redis自己创建双向链表来实现List数据结构，双向链表便于查询但是也增加了内存开销。

- 常用命令
  - RPUSH k v1 v2...：在指定列表右边插入数据。
  - LPUSH k v1 v2...：在指定列表左边插入数据。
  - LSET k index v：在指定列表指定位置插入值。
  - LPOP k：从左边移除并返回一个值。
  - RPOP k：从右边移除并返回一个值。
  - LLEN k：获得列表数量。
  - LRANGE k start end：获取列表start到end之间的数据。

- 使用场景
  - 最新文章，最新动态，Hot排行榜
  - 消息队列（不推荐，5.0后Stream类型实现较好，但是也不推荐）

## Hash
- 简介

类似Java中的HashMap，键与值的映射，底层类似数组+链表。

- 常用命令
  - HSET k f v：为指定key的字段设置值。
  - HSETNX k f v：当指定字段不存在时才设置值。
  - HMSET k f1 v1 f2 v2...：同时设置多个值。
  - HGET k f：获得指定hash的字段值。
  - HMGET k f1 f2...：获得多个字段值。
  - HGETALL k：获得hash所有的键值对。
  - HEXISTS k f：判断hash指定字段是否存在。
  - HDEL k f1 f2...：删除一个或多个hash字段。
  - HLEN k：获得hash中所有的字段。
  - HINCRBY key field increment：对hash中字段进行加减操作，正值加负数为减。

- 使用场景
  - 对象数据存储：用户信息，商品信息，文章信息等。

## SET
- 简介

Set集合是无序和唯一的。可以实现交集、差集和并集操作。

- 常用命令
  - SADD k v1 v2...：添加多个值。
  - SMEMBERS k：返回所有元素值。
  - SCARD k：获得集合元素数量。
  - SISMEMBER k member：判断指定元素是否存在集合中。
  - SINTER k1 k2...：获得所有集合交集。
  - SINTERSTORE resultKey key1 key2 ...：将所有交集存储在resultKey集合中。
  - SUNION k1 k2...：获得所有集合并集。
  - SUNIONSTORE resultKey key1 key2 ...：将所有并集存储在resultKey集合中。
  - SDIFF key1 key2 ...：获得所有集合差集。
  - SDIFFSTORE destination key1 key2 ...：将所有差集存储在resultKey集合中。
  - SPOP key count：随机移除并获得一个或多个元素。
  - SRANDMEMBER key count：随机获得一个或多个元素。

- 使用场景
  - 不重复场景：文章点赞用户，动态点赞等。
  - 集合处理：共同好友、共同粉丝、内容推荐等。
  - 随机场景：抽奖系统。

## Sorted SET
- 简介

ZSET添加了一个权重参数，使得set可以按照权重进行排序。

- 常用命令
  - ZADD k s1 v1 s2 v2 ...：添加多个值。
  - ZCARD KEY：集合数量。
  - ZSCORE key member：获得元素的权重值。
  - ZINTERSTORE destination numkeys key1 key2 ...：将所有集合交集保存在destination集合中，相同元素权重相加，numkeys结果元素数量。
  - ZUNIONSTORE destination numkeys key1 key2 ...：求交集，同上。
  - ZDIFF destination numkeys key1 key2 ...：求差集，同上。
  - ZRANGE key start end：获取指定有序集合 start 和 end 之间的元素（score 从低到高）。
  - ZREVRANGE key start end：获取指定有序集合 start 和 end 之间的元素（score 从高到底）。
  - ZREVRANK key member：获取指定有序集合中指定元素的排名(score 从大到小排序)。

- 使用场景
  - 排行榜。
  - 有优先级的数据。

# 特殊数据结构
## Bitmap
- 简介

Bitmap存储的是连续的二进制数。只需要使用一个位就可以记录元素的状态。我们可以给Bitmap看成一个数值，所以每个元素都有一个下标（偏移量从0开始）。

- 常用命令
  - SETBIT key offset value：设置指定位置（偏移量）值。
  - GETBIT key offset：获得指定位置值。
  - BITCOUNT key start end：获得从start到end值为1的数量
  - BITOP operation destkey key1 key2 ...：对一个或多个 Bitmap 进行运算，可用运算符有 AND, OR, XOR 以及 NOT。

- 使用场景
  - 需要保存状态数据：是否签到，是否活跃，是否点赞等。

## HyperLongLong

- 简介

HyperLogLog 是一种有名的基数计数概率算法 ，基于 LogLog Counting(LLC)优化改进得来，并不是 Redis 特有的，Redis 只是实现了这个算法并提供
了一些开箱即用的 API。 Redis 提供的 HyperLogLog 占用空间非常非常小，只需要 12k 的空间就能存储接近2^64个不同元素。

- 常用命令
  - PFADD key element1 element2 ...：添加一个或多个元素到 HyperLogLog 中。
  - PFCOUNT key1 key2：获取一个或者多个 HyperLogLog 的唯一计数。
  - PFMERGE destkey sourcekey1 sourcekey2 ...：将多个 HyperLogLog 合并到 destkey 中，destkey 会结合多个源，算出对应的唯一计数。

- 使用场景
  - 巨大数据量计算：热门网站每日/每周/每月访问 ip 数统计、热门帖子统计。

## Geospatial index
- 简介

地理空间索引，主要用于存储地理位置信息，基于 Sorted Set 实现。

- 常用命令
  - GEOADD key longitude1 latitude1 member1 ...：添加一个或多个元素对应的经纬度信息到 GEO 中。
  - GEOPOS key member1 member2 ...：返回给定元素的经纬度信息。
  - GEODIST key member1 member2 M/KM/FT/MI：返回两个给定元素之间的距离。
  - GEORADIUS key longitude latitude radius distance：获取指定位置附近 distance 范围内的其他元素，支持 ASC(由近到远)、DESC（由远到近）、Count(数量) 等参数。
  - GEORADIUSBYMEMBER key member radius distance：类似于 GEORADIUS 命令，只是参照的中心点是 GEO 中的元素。

- 使用场景
  - 附近的人。

# 常用命令
|命令|介绍|备注|
|---|---|---|
|TTL key|查询key还剩过期时间||
|DEL key|删除指定key||
|EXPIRE key seconds|给指定key设置过期时间||
||||

# 持久化
## RDB
周期性的持久化：
  - RDB会生成多个文件，每个文件代表某个时刻redis内数据。
  - RDB对redis性能影响非常小，rdb是在多线程下执行，主线程fork一个子线程进行备份。
  - 直接基于rdb进行系统重启和恢复速度较快，相较于aof
  - rdb是周期性备份，这也就是说redis在宕机后可能导致一部分时间数据丢失。
  - rdb虽然采用多线程，但是文件较大时也会有性能的影响，也有可能导致服务端内存溢出。

## AOF
AOF对每条命令作为日志，以applend-only模式添加到文件中。在Redis重启时，会回放日志文件命令进行数据恢复：
  - AOF每秒备份一次，所以最差大概丢失一秒数据。
  - 只写模式性能较高
  - AOF文件过大时会出现日志重写，这不会影响到客户端。对老日志进行压缩，这时新文件还继续加载日志。
  - AOF文件通常是比RDB文件大
  - AOF对redis的qps影响会有所影响

## 持久化抉择
1. RDB数据丢失问题，因为那会丢失较多数据。
2. AOF备份问题：1.AOF文件恢复没RDB快，2.RDB简单粗暴，避免AOF备份和恢复复杂机制。

# 事务
## 事务使用
可以通过multi、exec、discard、watch实现事务。

过程：
1. 开始事务multi
2. 命令入队(批量操作 Redis 的命令，先进先出（FIFO）的顺序执行)。
3. exec同时执行命令
4. discard可以退出事务，并清除命令队列
5. watch监视指定的key，当发送变化的时候整个事物都不会执行，直接返回失败。


