# 1. 标签

## 1.1 `<c:forEach>`

示例：

```xml

<c:forEach var="name" items="Collection" varStatus="statusName" begin="begin" end="end" step="step">
</c:forEach>
```

文件头添加依赖：`<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>`

属性：

- items: 需要遍历的集合
- var  : 单个对象（集合元素）标识符
- begin: 默认从0开始,表示从第几个开始取元素
- end  : 和begin对应,表示到第几个元素终止
- step : 步进,默认是1,表示一个一个跳,还是任意数字跳
- varStatus:  表示集合中每个元素的相关信息,有4种状态:index(所在位置，即索引).count(总共已迭代的次数).first(是否为第一个位置),last(是否为最后一个位置)

## 1.2 `<c:if>`

示例：

```xml
<c:if test="${menuActive eq 'home'}">
    active
</c:if>
```

- 字符串比较eq：a eq b