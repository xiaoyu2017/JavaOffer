**一、基础**

**1.书写位置**

1.行内（代码写在标签内部，）

2.内部（直接写在html文件里，用script标签包住，规范：script标签写在上面）

3.外部（代码写在以.js结尾的文件里，通过script标签，引入到html页面中，）

**2.变量使用**

let 变量名

let age

注意：let 不能重复声明

let和var的区别？

在较旧的JavaScript，使用关键字 var 来声明变量 ，而不是 let。 var 现在开发中一般不再使用它，只是我们可能再老版程序中看到它。 let 为了解决 var 的一些问题。 

var 声明: 

- 可以先使用 在声明 (不合理) 
- var 声明过的变量可以重复声明(不合理) 
- 比如变量提升、全局变量、没有块级作用域等等

**3.数组**

// 声明 let array = [ ] let arrays1 = new Array('C', 'B', 'A')

数组可以存储任意类型的数据

let arrays = ['A', 'B', 'C'] // 查 document.write(arrays[0]) // 改 arrays[0] = 'D' // 增 // 新增一个或多个元素到尾部并返回新增后数组长度 arrays.push('D', 'E') // 新增一个或多个元素到头部并返回新增后数组长度 arrays.unshift('0', '1') // 删除 // 删除最后一个元素，并返回改值 arrays.pop() // 删除第一个元素，并返回改值 arrays.shift() // 删除指定元素，(开始位置，[删除个数(可选，不传递删除到最后)]),返回删除元素数组 arrays.splice(start，unm)

**4.常量**

- **概念：**使用 const 声明的变量称为“常量”。 
- **使用场景：**当某个变量永远**不会改变**的时候，就可以使用 const 来声明，而不是let。 
- **命名规范：**和变量一致 
- **注意：** 常量不允许重新赋值,声明的时候必须赋值（初始化） 
- **小技巧：**不需要重新赋值的数据使用const 

**5.数据类型**

**5.1基本数据类型**

1. number 数字型 
2. string 字符串型 

通过单引号（ ''） 、双引号（ ""）或反引号( ` ) 包裹的数据都叫字符串。

模板字符串：

`` (反引号) 

在英文输入模式下按键盘的tab键上方那个键（1左边那个键）

内容拼接变量时，用 ${ } 包住变量

1. boolean 布尔型 
2. undefined 未定义型 
3. null 空类型

null 和 undefined 区别： 

undefined 表示没有赋值 

null 表示赋值了，但是内容为空

**5.2引用数据类型**

1. object 对象

**5.3数据类型检测**

typeof 运算符可以返回被检测的数据类型。它支持两种语法形式： 

1. 作为运算符： typeof x （常用的写法） 
2. 函数形式： typeof(x)

**5.4类型转换**

隐式转换：

- \+ 号两边只要有一个是字符串，都会把另外一个转成字符串
- 除了+以外的算术运算符 比如 - * / 等都会把数据转成数字类型

显式转换：

Number(数据) 

转成数字类型 

如果字符串内容里有非数字，转换失败时结果为 NaN（Not a Number）即不是一个数字 

NaN也是number类型的数据，代表非数字 

parseInt(数据) 

只保留整数 

parseFloat(数据) 

可以保留小数

String(数据) 

变量.toString(进制)

Boolean(内容)

‘’、0、undefined、null、false、NaN 转换为布尔值后都是false, 其余则为 true

**6.函数**

// 声明 function fun(){    ... } // 参数 function fun1(arg1, arg2, ...){     } // 参数默认值 function fun2(arg1 = 0, arg2 = 0, ...){     } // 返回值 function fun3(num1，num2){    return num1 + num2 } // 匿名函数 // 函数表达式 let fun4 = function() { } fun4() // 立即执行函数(防止全局变量污染)，尾部需要加分号 (function(){})();

函数内给未声明变量赋值，该变量变成全局变量。

变量访问采用就近原则，先函数内，再外部直到访问到。

**7.对象**

// 声明 let obj = {} let obj1 = new Object() let obj2 = {    name: 'tim',    age:18,    sun: function(){        alert('hi')        } } // 增-直接添加新属性和值 obj2.address = 'sh' // 删 delete obj2.name // 改 obj2.name = 'tom' // 查 obj2.name // 特殊属性使用 let obj4 = {    'nick-name': 'heny' } // 查([ ]中值可以不加单双引号，会当变量解析) obj4['nick-name']

对象遍历：

let obj = {    name:'tim',    age:18,    address:'sh' } for (let k in obj){    console.log(k)    console.log(obj[k]) }

**8.内置对象**

**8.1 Math**

random：生成0-1之间的随机数（包含0不包括1）

ceil：向上取整

floor：向下取整

max：找最大数

min：找最小数

pow：幂运算

abs：绝对值

**二、WebApi**

**1.获得元素**

// 获得满足条件的第一个元素，没有返回null document.querySelector('***') // 获得满足条件的多个元素(伪数组) /* 伪数组：有长度，有索引，没有pop和push等方法 */ document.querySelectorAll('***')

**2.修改文本内容**

元素.innerText('***')：显示纯文本，不解析标签。

元素.innerHtml('***')：解析标签。

**3.属性操作**

基本语法：元素.属性 = 值

const pic = document.querySelector('img') pis.src = './images/b02.jpg' pic.title = 'haha'

**4.元素样式属性操作**

**4.1 通过style操作**

语法：元素.style.属性 = 值

const box document.querySelector('.box') box.style.witdh = '200px' // 如果属性有-连接符，需要转换为小驼峰命名法 box.style.marginTop = '15px'

**4.2通过className操作**

语法：元素.className = 值

className是使用新值换旧值, 如果需要添加一个类,需要保留之前的类名

// className是使用新值换旧值, 如果需要添加一个类,需要保留之前的类名 box.className = 'active'

**4.3通过ClassList操作**

box.classList.add('active') box.classList.remove('box') box.classList.toggle('hiddle')

**5.自定义属性**

语法：

获得值：元素.dataset.id

标签属性以data-***开头

**6.定时器**

开启：const x = setInterval(函数， 间隔时间)

关闭：clearInterval(x)

**7.事件**

**7.1 事件监听**

// 方式一 元素.addEventListener('事件类型', function () {    }) // 方式二 元素.on事件类型 = function(){    }

on方式会被覆盖，addEventListener方式可绑定多次，拥有事件更多特性，推荐使用

**7.2 事件类型**

1. click 鼠标点击
2. m o u s e e n t e r 鼠标经过
3. mouseleave 鼠标离开
4. focus 获得焦点
5. blur 失去焦点
6. Keydown 键盘按下触发
7. Keyup 键盘抬起触发
8. input 用户输入事件

**7.3事件对象**

​    ![0](https://note.youdao.com/yws/res/12277/WEBRESOURCE1b5c0fb10405ea5fce9520becfb65a42)

1. ev.type： 当前事件的类型
2. ev.clientX/Y： 光标相对浏览器窗口的位置
3. ev.offsetX/Y： 光标相于当前 DOM 元素的位置

**7.4事件流**

事件流指的是事件完整执行过程中的流动路径

​    ![0](https://note.youdao.com/yws/res/12285/WEBRESOURCE0cc4372c8fc592e87af81304c232bfca)

**7.4.1事件冒泡**

// 事件从子到父逐级触发 // documentElement.addEventListener(事件类型, 事件处理函数, 是否使用捕获机制) // html 元素添加事件 document.documentElement.addEventListener('click', function () {    console.log('html...') }) // body 元素添加事件 document.body.addEventListener('click', function () {    console.log('body...') }) // 外层的盒子添加事件 outer.addEventListener('click', function () {    console.log('outer...') }) // outer... // body... // html...

**7.4.2事件捕获**

// 事件从父到子逐级触发 // documentElement.addEventListener(事件类型, 事件处理函数, 是否使用捕获机制) // html 元素添加事件 document.documentElement.addEventListener('click', function () {    console.log('html...') }, true) // body 元素添加事件 document.body.addEventListener('click', function () {    console.log('body...') }, true) // 外层的盒子添加事件 outer.addEventListener('click', function () {    console.log('outer...') }, true) // html... // body... // outer...

**7.4.3阻止冒泡**

//  阻止冒泡 outer.addEventListener('click', function (e) {    console.log('child...')    // 阻止冒泡方法    e.stopPropagation() })

**7.4.4阻止默认行为**

//  阻止默认行为 outer.addEventListener('click', function (e) {    console.log('child...')    e.preventDefault() })

**7.4.5解绑事件**

// on** 方式解绑 元素.onClick = null // addEventListener解绑 function fn(){    ... } // 添加事件 元素.addEventListener('click', fn) // 解绑 元素.removeEventListener('click', fn)

注意：匿名函数无法被解绑

**7.4.6事件委托**

需求：给多个li标签注册事件，for循环较为繁琐或事件委托

事件委托是利用事件流的特征解决一些开发需求的知识技巧

1. 优点：减少注册次数，可以提高程序性能
2. 原理：事件委托其实是利用事件冒泡的特点。
3. 给父元素注册事件，当我们触发子元素的时候，会冒泡到父元素身上，从而触发父元素的事件
4. 实现：事件对象.target. tagName 可以获得真正触发事件的元素

<body> <ul>     <li id="1">111111111111</li>     <li id="2">222222222222</li>     <li id="3">333333333333</li>     <li id="4">444444444444</li>     <li id="5">555555555555</li>     <li id="6">666666666666</li> </ul> <script>     var ulDoc = document.querySelector('ul');      ulDoc.addEventListener('click',function (e) {         console.log(e.target.id)     }) </script> </body>

**7.4.7页面加载、元素滚动、页面尺寸事件**

页面加载（全部资源加载完成）：

​    ![0](https://note.youdao.com/yws/res/12354/WEBRESOURCEf6886cf8103f03c06852c0d2a3895cd7)

页面加载（页面初始内容加载完成）：

​    ![0](https://note.youdao.com/yws/res/12355/WEBRESOURCEd4af78a42aaf2f97aa1ef7e19f0e4ab1)

页面滚动事件：

window.addEventListener('scroll', function() {    // xxxxx })

页面滚动到指定位置：

元素.scrollTo(x, y)

页面尺寸事件：

window.addEventListener('resize', function() {    // xxxxx })

元素尺寸于位置：

| 属性                        | 作用                                     | 说明                                                     |
| --------------------------- | ---------------------------------------- | -------------------------------------------------------- |
| scrollLeft和scrollTop       | 被卷去的头部和左侧                       | 配合页面滚动来用，可读写                                 |
| clientWidth 和 clientHeight | 获得元素宽度和高度                       | 不包含border,margin，滚动条 用于js获取元素大小，只读属性 |
| offsetWidth和offsetHeight   | 获得元素宽度和高度                       | 包含border、padding，滚动条等，只读                      |
| offsetLeft和offsetTop       | 获取元素距离自己定位父级元素的左、上距离 | 获取元素位置的时候使用，只读属性                         |

**三、进阶**

**1.作用域**

局部变量：

- 函数作用域：只能函数内访问。
- 块作用域：{ }内访问，let、const。

全局变量：（尽量少用全局变量）

在script标签和.js文件最外层直接声明的变量就是全局变量，可以被其他地方任一访问。

<script>     const pi = 3.14 </script>

注意：

window对象动态添加的属性为全局变量。

函数中使用未经过任何关键字声明的变量是全局变量。

**2.作用域链**

let a = 1 function f() {    let a = 2    function g() {        a = 3        console.log(a)    }    g() } f() // 执行结果 3

作用域链本质就是变量查找机制。在函数被执行时，会优先查找当前函数作用域中查找变量。如果当前作用域查找不到则会依次逐级查找父级作用域直到全局作用域。子作用域能够访问父作用域，父级作用域无法访问子级作用域

**3.闭包**

闭包 = 外层函数变量 + 内层函数

闭包作用：封闭数据，提供操作，外部也可以访问函数内部的变量

闭包引发的问题：内层泄漏

// 函数调用次数 let num = 1 function fun(){    num++    ... } // num是全局变量，容易被修改  function fun1(){    let num = 1    function fun(){        num++        ...        } } // num 私有就不会被修改

**4.函数**

动态参数（实参数量不定）

// 1.内置变量 function count(){    // 通过arguments获得用户传递的所有参数    for(let i = 0;i < arguments.length; i++){            ...    } } // 2.剩余参数(推荐使用) function fun(arg1, arg2, ...args){    // ...为展开符，得到一个真数组 }

**5.展开运算符**

 ... 为展开运算符：

用在形参：得到数组

用在数组中：数组展开

// 用在数组中 let arrays  = [1,2,3,4] // 数组直接展开显示 console.log(...arrays)  // 求最大值 console.log(Math.max(...arrays)) // 求最小值 console.log(Math.min(...arrays)) let arrays2 = [5,6,7,8] // 数组合并 let arrays3 = [...arrays,...arrays2]

**6.箭头函数**

// 1.基本用法 let x = function(){    ... } let x = () => {    ... } // 2.只有一个参数(括号可以省略) let x = function(y){    ... } let x = y => {    ... } // 3.只有一行方法体(可写在一行，并且return可以省略) let x = function(y){    return y++ } let x = y => y++ // 4.加括号的方法体会返回对象字面量表达式 let x = name => ({name: name}) // 结果：{name：'tim'}

注意：

箭头函数没有arguments，有剩余函数。

**7.解构赋值**

**7.1数组解构**

基本语法：赋值号=左侧为批量声明变量，右侧为数组值

// 例如： let [a,b,c] = [1,2,3] console.log(a) //1 console.log(b) //2 console.log(c) //3

经典问题：两个值交换

let a = 1 let b = 2;    // 需要加分号 [b, a] = [a, b] // a = 2 // b = 1

注意：数组开头语句前一行需要添加分号，例如上面代码。立即执行函数也需要加。

1.变量少，数组元素多。

多余的变量将被赋值为 undefined

2.变量多，数组元素少。

仅显示变量获得到的值

3.使用剩余参数解决变量少问题。(剩余参数只能放最后)

[a, b, c, ...other] = [1, 2, 3, 4, 5, 6] /* a=1 b=2 c=3 other = [4,5,6] */

4.防止undefined问题，可以设置默认值。

[a = 0, b = 0, c = 0, d = 0] = [1, 2, 3]

5.按需导入，可以跳过某些元素。

[a, ,b, c, d] = [1, 2, 3, 4, 5]

**7.2对象解构**

基本语法同数组解构，只不过将 [ 括号换成 { 。

// 例如 let user = {    name: 'time',    age: 18 }; // 变量名不能发送冲突，必须与对象属性名称一致，变量名相同属性找不到赋值undefined let {name, age} = user; console.log(name); console.log(age);

1.更改变量名

let user = {    name: 'time',    age: 18 }; //将name变量值赋值给uname新变量名 let {name: uname, age} = user; console.log(uname); console.log(age);

2.数组对象嵌套解构

let users = [{    name: 'time',    age: 18 }]; let [{name, age}] = users; console.log(name); console.log(age);

3.嵌套解构

// 多级 let users = [{    name: 'tim',    family: {        mother: 'rouse',        father: 'jack'    },    age: 18 }]; let [{name, family: {mother, father}, age}] = users; console.log(name); console.log(age); console.log(mother); console.log(father);

4.函数使用

let users = {    name: 'tim',    family: {        mother: 'rouse',        father: 'jack'    },    age: 18 }; function test({family}) {    console.log(`family:${family.mother}`) } test(users)

**8.构造函数**

// 示例 function People(name, age){    this.name = name    this.age = age } let student = new People('jack', 18)

构造函数本质上就是特殊的函数，所以技术上和函数一样。

注意事项：

函数名采用大驼峰命名。

需要使用new关键字调用，这个过程被称为实例化对象。

构造方法不需要return，写了也会无效。

**9.实例成员&静态成员**

​    function People(name, age) {        this.name = name        this.age = age        this.look = function () {            return 'look'        }    }     People.eyes = 2    People.arms = 2    People.say = function () {        return 'say'    }     let student = new People('jack', 18)    console.log(`实例属性：${student.name}`)    console.log(`实例方法：${student.look()}`)    console.log(`静态属性：${People.eyes}`)    console.log(`静态方法：${People.say()}`)

**10.内置对象**

**10.1 Array**

**10.1.1	forEach**

基本语法：数组.forEach(fucntion(元素，[元素索引]){ ... })

let arrays = [1, 2, 3, 4, 5, 6]; arrays.forEach(function (x, y) {    console.log(`${x}==>${y}`); });

**10.1.****2	filter**

基本语法：数组.filter(fucntion(元素，[元素索引]){ return 过滤条件 })

let arrays = [1, 2, 3, 4, 5, 6]; let x = arrays.filter(function (x, y) {    return x > 3; }) console.log(x)

**10.1.2	map**

基本语法：数组.map(fucntion(当前元素   [,元素索引]   [,当前数组]){ 处理元素 }   [, 回调函数this值，不设置this表示全局对象])

let arrays = [1, 3, 5, 7, 9]; arrays = arrays.map(function (val, index) {    return val += 1 }); console.log(arrays)

**10.1.3	reduce**

基本语法：数组.reduce(fucntion(统计结果值,  元素值,   [,元素索引]   [,当前数组]){ 处理元素 }   [, 初始值])

let arrays = [1, 3, 5, 7, 9]; let num = arrays.reduce(function (total, val, index, arr) {    return val + total }, 10) console.log(num)

**四、axios**