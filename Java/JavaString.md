# 1. String，StringBuilder，StringBuffer比较

|特性|String|StringBuilder|StringBuffer|
|---|---|---|---|
|线程安全|❎|❎|✅|
|可变|❎|✅|✅|

# 2. 创建String

|方式|说明|
|---|---|
|String s = "ABC"|直接在常量池中创建对象|
|String s = newString("ABC")|直接在堆中创建实例，若字符串在常量池中就指向引用|
|String s = "AB"+"CD"|类似String s = "ABCD",直接放进常量池中，只有字面量拼接才会被优化|

# 3. StringBuffer

## 3.1 常用方法

|方法|说明|
|---|---|
|reverse()|字符串反转|

# 4. StringBuilder

## 4.1 常用方法
|方法|说明|
|---|---|
|reverse()|字符串反转|

# 5. String

## 5.1 常用方法

|方法|说明|
|---|---|
|indexOf()|返回指定字符的位置|
|length()|返回字符串长度|
|replace()|替换字符串|
|charAt()|返回指定字符位置|
|split()|分割字符串，返回数值|
|trim()|去掉两头空格|
|toLowerCase()|转为小写|
|toUpperCase()|转为大写|
|subString()|截取字符串|

