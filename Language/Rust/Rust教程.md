# 1. 安装

使用rustup下载，这是一个管理Rust版本和相关工具的命令行工具。

> Linux和macOS安装

先安装rustup

```shell
curl --proto '=https' --tlsv1.3 https://sh.rustup.rs -sSf | sh
```

安装成功提示如下：`Rust is installed now. Great!`

Rust依赖于C语言，所以需要安装C编译器。Mac需要安装`xcode-select --install`，Ubuntu需要安装GCC和CLang。

检验安装结果：`rustc --version`

更新：`rustup update`

卸载：`rustup self uninstall`

# 2. 创建项目

创建目录：

```shell
mkdir hello_rust
cd hello_rust
touch main.rs
```

main.rs

```rust
fn main() {
    println!("Hello, world!");
}
```

运行：

```shell
rustc main.rs
./main
Hello, world!
```

# 3. Cargo创建项目

cargo在安装Rust默认是安装cargo的，cargo创建的项目默认会初始化git。

创建项目：

```shell
cargo new cargo_rust
cd cargo_rust
```

`Cargo.toml`cargo项目的配置文件

```toml
[package]
name = "cargo_rust"
version = "0.1.0"
edition = "2021"

# See more keys and their definitions at https://doc.rust-lang.org/cargo/reference/manifest.html

[dependencies]
```

项目结构： |-src |-main.rs |-target（编译或运行后出现） |-debug（存放调试编译后代码） |-release（存放优化后编译文件） |-Cargo.toml

构建项目：`cargo build`（构建快，执行一般）

优化构建项目：`cargo build --release`（构建慢，执行相对快）

运行项目：`cargo run`

快速检测代码：`cargo check`

# 4. 基础语法

## 4.1 定义变量

Rust中被定义的变量默认是不能被修改的，类似常量。用let关键字修饰，定义可改变变量需要添加mut关键字。

```rust
fn main() {
    // 定义不可变变量，一旦赋值就不可改变
    let x = 5;
    // x = 10; 这样会编译不通过，报错

    // 定义可变变量，可多次修改
    let mut y = 6;
}
```

## 4.2 定义常量

常量总是不能改变的，使用const定义。

```rust
fn main() {
    const PI: f32 = 3.14;
}
```

## 4.3 隐藏Shadowing

在rust中可以使用相同变量名，但是会覆盖前一个相同变量名，以上是在相同作用域中。如果在子作用域中使用相同变量就会隐藏前变量，但是不会覆盖。 变量隐藏可以改变变量类型。隐藏前者时需要向新定义变量一样使用let关键字。

```rust
fn main() {
    let x = 1;
    let x = x + 1;
    {
        let x = x * 2;
        println!("1=>:{x}")
    }
    println!("2=>:{x}")
}
```

> 以上结果：
>
> 1=>:4
>
> 2=>:2


**_可变变量和隐藏区别：_**

1. 要隐藏前者变量，需要添加let关键字否则就会报错。
2. 可变变量数据类型不可修改，隐藏类似新建变量所以变量可不同。

## 4.4 数据类型

### ①. 标量类型

1. 整型：默认类型i32

|长度|有符号|无符号|
|---|---|---|
|8-bit|i8|u8|
|16-bit|i16|u16|
|32-bit|i32|u32|
|64-bit|i64|u64|
|128-bit|i128|u128|
|arch|isize|usize|

字面量表示类型：

|进制|例子|
|---|---|
|十进制|1000，1_000|
|十六进制|0xff|
|八进制|0o12|
|二进制|0b10010|
|单字节字符|b'A'|

> 直接在数值后面添加类型 100u32

2. 浮点型：默认类型f64

两种：f32，f64，都是有符号浮点类型

3. 布尔型

bool：只有两个值true和false

4. 字符型

char：表示单个字符

### ②. 复合类型

1. 元组类型：元素类型可不相同，长度一旦固定不可改变

将用圆括号包裹起来以逗号隔开的一组数据称为元组。从元组中获得值，也可以使用.加索引来获得单个值；

```rust
fn main() {
    let tup: (u8, i32, char) = (1, -4, 'a');
    // 模式匹配来解构元组值
    let (x, y, z) = tup;
    // 索引获得
    let a = tup.0;
    println!("{x},{y},{z}");
    println!("{a}");
}
```

**_不带任何值的元组：单元元组_**
这种值一般写为()，通常用于返回空值或空的类型。

2. 数组：元数类型相同，长度固定不可变

数组定义与使用如下：

```rust
fn main() {
    // 给定值
    let x = [-3, -2, -1, 0, 1, 2, 3, 4, 5, 6];
    // 通过设置类型
    let y: [u32; 5] = [1, 2, 3, 4, 5];
    // 通过设置相同初始值，六个元素，值都为9
    let z = [9; 6];
    let a = x[0];
    let b = y[0];
    let c = z[0];
    println!("{a}");
    println!("{b}");
    println!("{c}");
}
```

## 4.5 函数

1. 函数定义和调用

main是程序的入口，然后通过main函数调用其他函数。

```rust
fn main() {
    println!("main run");

    a_function();
}

fn a_function() {
    println!("a_function run")
}
```

2. 参数

定义函数的形参时必须指定参数类型，多个形参之间使用逗号隔开。

```rust
fn main() {
    temp(1f64, 3.14);
}

fn temp(x: f64, y: f64) {
    let z = x + y;
    println!("{z}");
}
```

3. 语句和表达式

在rust中语句和表达式是有严格界限的，语句是没有返回值，表达式是有返回值的。例如`let x = 5;`这就是语句，而`x + y`是表达式。这样就与其他语言有了 不同，例如`x = y = 5` 在rust中是不成立的。

常量、函数、代码块（{}大括号括起来的部分）、宏调用这些都是表达式（可以有返回值）。

4. 函数返回值

需要在定义函数时，需要添加->数据类型，来表示返回的类型。在函数体中可以使用return或者默认最后一个表达式返回。

```rust
fn main() {
    let a = add(1, 2);
    println!("{a}")
}

fn add(x: i32, y: i32) -> i32 {
    x + y
}
```

在以上事例中可以看出，add函数只有一行，没有使用return也可返回值，为最后一行表达式，并且**最后一行不能添加分号;**

## 4.4 注释

单行注释：`//这是一行注释`

## 4.5 控制流

1. if条件判断

```rust
fn main() {
    let num = 10;
    if num < 100 {
        println!("num < 100");
    } else {
        println!("num > 100");
    }
}
```

当把if作为表达式在let语句中使用时，就需要每个条件的返回值都是一样的类型。

```rust
fn main() {
    let x = true;
    // let a = if x {2} else { 'a' }; 这样的语句就会报错，以下则正确运行。
    let a = if x { 2 } else { 3 };
    println!("{a}")
}
```

2. 循环loop、while、for

loop:无限循环下去，可以通过continue或者break跳过或跳出循环

```rust
fn main() {
    loop {
        println!("ABCDEFGHIJKLMN");
    }
}
```

loop一般用于重复尝试某种易失败操作，例如网络请求等，它也是一种表达式，具有返回值。

```rust
fn main() {
    let mut num = 0;
    let x = loop {
        num += 1;
        if num == 10 {
            break num * 10;
        }
    };
    println!("{x}")
}
```

多循环嵌套为防止跳出歧义使用**循环标签**

```rust
// 循环标签使用
fn main() {
    let mut x = 0;
    'loop1: loop {
        let mut y = 0;
        'loop2: loop {
            if y == 9 {
                break 'loop2;
            }
            if x == 5 {
                break 'loop1;
            }
            y += 1;
            println!("loop2 run...");
        }
        x += 1;
        println!("loop1 run...");
    }
    println!("loop end...");
}
```

while：判断是否符合条件，符合运行否则就结束,也可以使用continue和break跳出循环。也可以通过loop、if、else、break等来实现。

```rust
fn main() {
    let mut x = 0;
    while x < 10 {
        println!("while is run ...");
        x += 1;
    }
    println!("while is end...");
}
```

for：使用for来遍历集合。

```rust
fn main() {
    let a = [1, 2, 3, 4, 5, 6];
    for item in a {
        println!("show array num: {}", item);
    };
    println!("for end...");
}
```

指定下标显示集合内容

```rust
fn main() {
    for item in 0..6 {
        println!("num: {}", item);
    }
}
```

# 5. 所有权

Rust中最为与众不同的特性，这使得Rust在不使用垃圾回收机制就可实现内存安全。

## 5.1 什么是所有权

所有权规则：

- rust中任何一个值都有一个所有者。
- 值在任一时刻只有一个所有者。
- 当所有者离开作用域，值将会被丢弃。

值作用域：即一个值在程序中有效的范围

```rust
fn main() { // 值x是无效的，未声明 
    let x = 1; // 此时x值有效
}// 作用域结束，值无效
```

rust在值离开作用域时，会执行drop，对没有所有权的值进行内存释放。

## 5.2 所有权下内存释放复杂情况的解决方案

1. 变量数据交互：移动

```rust
fn main() {
    let x = string::from("Hello");
    let y = x;
    // println!("{}",x) 这样编译会报错
}
```

当x类型为string，在栈中存放了一个值包含字符串内容地址（指向堆中地址）、字符串长度和字符串容量。y为x的副本，拷贝了x的三种信息，但是堆中内容并没有拷贝。这就到时x、y同时指向同一个内容地址。这就是其他语言中的深浅拷贝。

当离开作用域时，rust调用drop会对x和y同时进行内存释，x、y又同时指向同一个堆内存，这就导致内存**二次释放**的错误导致内存污染。为了确保内存的安全，rust采用以下方案。

当x生成副本y之后就不在有效，再调用x时就会报错，他不再是一个有效值。既然已近无效，在释放时也就不会再考虑了。相比深浅拷贝，rust这种方案更适合解读为***移动***

2. 变量数据交互：克隆

当在一定情况下确实需要深度拷贝（一般不会这么做，会导致内存占用较大），我们可以调用类型的clone函数。

```rust
fn main() {
    let s1 = String::from("hello");
    let s2 = s1.clone();
    println!("s1:{}, s2:{}", s1, s2)
}
```

3. 只在栈上克隆数据：拷贝

当数据只在栈上拷贝，就不会出现移动那种情况。而且第一个变量不会无效，因为这些数据类型固定较小。

```rust
fn main() {
    let x = 5;
    let y = x;
    println!("x:{}, y:{}", x, y); // 这样调用并不会报错
}
```

以上就会与第一种移动示例冲突，但是深入了解就会发现其底层拷贝完全不同。Rust中有一种特殊注解，Copy特性注解。以下类型符合这种特性（类似java中基础类型）。

有Copy特性注解：

- 整型、浮点型、布尔、字符。
- 元组：元数类型必须有Copy特性，(u32, String)就不行。

4. 所有权和函数

原理和变量传递类似。

```rust
fn main() {
    let a = String::from("hello");
    show_str(a);

    // println!("x:{}", x) 不能再调用，x以无效

    let x = 3;
    let y = 4;
    let num = add(x, y);
    println!("{} + {} = {}", x, y, num); // 在这里是可以调用的
}

fn show_str(str: String) {
    println!("{}", str)
}// str 作用域结束调用drop，值无效

fn add(x: i32, y: i32) -> i32 {
    x + y
}// x、y副本失效，原变量不失效
```

5. 所有权和返回值

返回值可以转移所有权。看如下示例：

```rust
fn main() {
    let x = String::from("hello"); // x所有权转移给one_fun函数，x值无效
    let y = one_fun(x); // x 所有权转义给y
    let z = two_fun(y);
    println!("z: {}", z)
}// 作用域结束，调用drop，释放z值，x、y值无效不管。

fn one_fun(x: String) -> String {
    x
}

fn two_fun(y: String) -> String {
    y
}
```

以上代码重复出现所有权转移，比较繁琐。而且如果我们返回值不是x是其他值，但是还想继续拥有x的所有权该如何实现了，可以使用元组返回。示例如下：

```rust
fn main() {
    let x = String::from("hello");
    let (y, len) = temp(x);
    println!("string:{}, len:{}", y, len)
}

fn temp(x: String) -> (String, usize) {
    let len = x.len();
    (x, len)
}
```

## 5.3 引用和借用

1. 引用（不可变引用）

调用函数来转移所有权，虽然可以通过返回元组来实现保留原变量所有权同时返回其他值，但是这看上去不太美观，rust提供了引用传递来实现这一需求。示例如下：

```rust
fn main() {
    // 创建变量s,s作用域开始
    let s = String::from("hello");
    // 向函数传递变量s引用    
    show(&s);

    // 此作用域变量s任然有效
    print!("s:{}", s);
}

fn show(str: &String) { // 借用s变量
    println!("借用内容：{}", str) // 进行操作
}// 函数结束，并未拥有值的所有权，不做任何操作
```

创建引用这一行为称为**借用**，类似我们向别人借用工具，使用完后需要返回给别人，至于工具是否丢弃或升级（修改）这是工具的所有者可以决定的。

上述示例引用是不可以修改变量的，否则rust会报错，这就类似借来的工具你没有处置权，仅仅有使用权。

```rust
fn main() {
    // 创建变量s,s作用域开始
    let s = String::from("hello");
    // 向函数传递变量s引用    
    show(&s);

    // 此作用域变量s任然有效
    print!("s:{}", s);
}

fn show(str: &String) { // 借用s变量
    str.push_str(" rust!"); // 这里编译不会通过，引用不可修改 
    println!("借用内容：{}", str) // 进行操作
}// 函数结束，并未拥有值的所有权，不做任何操作
```

2. 可变引用

如果非要对引用进行修改，这时就需要可变引用，`&mut param`，**使用可变引用必须让原变量为可变mut**

```rust
fn main() {
    // 创建变量s,s作用域开始
    let mut s = String::from("hello");
    // 向函数传递变量s引用
    show(&mut s);

    // 此作用域变量s任然有效
    print!("s:{}", s);
}

fn show(str: &mut String) { // 借用s变量
    println!("借用内容：{}", str); // 进行操作
    str.push_str(" rust!"); // 这里编译会通过，这里使用的是可变引用
}// 函数结束，并未拥有值的所有权，不做任何操作
```

在rust中非常谨慎的使用可变引用，因为可变引用会带来**数据竞争**问题。所以可变引用使用限制较多，①同一时刻（作用域）只能有一个可变引用，且不能有引用。②同一时刻可以有多个引用。（引用指的是不可变引用）

```rust
fn main() {
    let mut s = String::from("hello");
    let x = &s;
    // 编译不会通过，出现重复可变引用。
    let y = &s;
}
```

```rust
fn main() {
    let mut s = String::from("hello");
    let x = &s;
    {
        // 编译会通过，不同作用域出现可变引用
        let y = &s;
    }
}
```

```rust
fn main() {
    let s = String::from("hello");
    let x = &s;
    let y = &s;
    println!("s:{}, x:{}, y:{}", s, x, y) // 可正常运行，可多次使用引用
}
```

```rust
fn main() { // 以下编译也会通过，这是因为println函数已近使用过，不在借用可变引用，所有y变量可以继续借用。
    let mut s = String::from("hello");
    let x = &mut s;
    println!("第一次借用可变引用：{}", x);
    let y = &mut s;
    println!("第二次借用可变引用：{}", y);
}
```

```rust
fn main() { // 引用和可变引用混用会报错
    let mut s = String::from("hello");
    let x = &s; // 编译通过
    let y = &s; // 编译通过
    let z = &mut s; // 编译错误
    println!("{}, {}, and {}", x, y, z);
}
```

3. 悬垂引用

提到悬垂引用就要说到悬垂指针，当一个内容地址被释放，但是指向此地址的指针被保留，但此内容地址可能被分配给其他所有者。rust为了防止这一情况出现，就会在编译时期指出这类错误。

```rust
fn main() { // 会直接报错，因为Rust是不允许出现悬垂引用，同样基础类型也不行（整型，浮点型...）
    let x = get_str();
    println!("{}", x);
}

fn get_str() -> &String { // 返回值引用
    let s = String::from("hello rust!"); // 创建s变量，同时s变量在作用域中开始生效
    &s // 返回引用
} // 作用域结束，drop释放s，这时返回的引用就指向空的内容地址
```

_**总结：**_

- 同一作用域，要么只有一个可变引用，要么有多个引用。
- 引用总是有效。（不是悬垂引用）

> 引用类似判断传递的参数是值还是引用（这里的引用是java语言中的），对与可变引用的限制，很类似锁机制。不可变引用类似乐观锁，可变引用类似悲观锁。此部分仅为个人理解。

## 5.5 字符串slice

便于理解，我们实现一个简单的需求：找出一段话中第一个单词，就一个单词直接返回。（单词结束位置下标）

```rust
fn main() {
    let s = String::from("This is test");
    let result = first_word(&s);
}

fn first_word(str: &String) -> usize {
    let bytes = str.as_bytes();
    for (i, &item) in bytes.iter().enumerate() {
        if item == b' ' {
            return i;
        }
    };
    str.len()
}
```

但是现在在first_word函数执行结束后将s变量清理，这就会导致result变量的存在毫无意义，毕竟他是以变量s作为参考的。

```rust
fn main() {
    let mut s = String::from("This is test");

    let result = first_word(&s);

    s.clear();// 逻辑上是存在问题的，但是编译是可以通过的
}

fn first_word(str: &String) -> usize {
    let bytes = str.as_bytes();
    for (i, &item) in bytes.iter().enumerate() {
        if item == b' ' {
            return i;
        }
    };
    str.len()
}
```

有没有一种方法可以直接获得内容，但是不依赖原数据了，rust解决方案是新增一个字符串类型**字符串slice**，表示类型使用 **`&str`**。 使用slice类型对代码进行修改：

```rust
fn main() {
    let mut s = String::from("This is test");
    let result = first_word(&s);
    println!("result:{}", result);
}

fn first_word(str: &String) -> &str {
    let len = str.len();
    let bytes = str.as_bytes();
    for (i, &item) in bytes.iter().enumerate() {
        if item == b' ' {
            return &str[..i];
        }
    };
    &str[..len]
}
```

在rust中字面量字符串类型就是&str，所有在这里就可以对以上代码进行修改：

```rust
fn main() {
    let result = first_word("This is test");
    println!("result:{}", result);
}

fn first_word(str_temp: &str) -> &str {
    let len = str_temp.len();
    let bytes = str_temp.as_bytes();
    for (i, &item) in bytes.iter().enumerate() {
        if item == b' ' {
            return &str_temp[..i];
        }
    };
    &str_temp[..len]
}

```

其他类型的slice。

数组slice：

```rust
fn main() {
    let x = [1, 2, 3, 4, 5];
    let y = &x[..3];
    println!("{},{}", y[0], y[1]);
}
```

# 6. 结构体

结构体类似元组，但是不同的是，元组只能通过下标设置值，结构体可以通过属性名称获得或者设置值。

## 6.1 创建使用结构体

定义使用结构体：

```rust
struct User {
    name: String,
    active: bool,
    email: String,
    age: u8,
}

fn main() {
    let user = User {
        name: String::from("Fish"),
        email: String::from("fish@email.com"),
        active: true,
        age: 18,
    };
    println!("{}", user.name);
}
```

通过少量的修改来创建一个新的结构体实例，其他属性的值不变。以往这是一个繁琐和无意义的步骤，在rust中可以通过结构体更新语法实现。

结构体更新语法：

```rust
struct User {
    name: String,
    active: bool,
    email: String,
    age: u8,
}

fn main() {
    let user1 = User {
        name: String::from("Fish"),
        email: String::from("fish@email.com"),
        active: true,
        age: 18,
    };

    // 以往的写法
    // let user2 = User {
    //     name: String::from("yuhuai"),
    //     email: user1.email,
    //     active: user1.active,
    //     age: user1.age
    // };

    let user2 = User {
        name: String::from("yuhuai"),
        // 结构体更新语法
        ..user1
    };

    // 编译报错，遵循所有权。email被移动
    // println!("user1 name:{}, email:{}", user1.name, user1.email);
    // println!("user2 name:{}, email:{}", user2.name, user2.email);

    // 正常编译运行
    println!("user1 name:{}, active:{}", user1.name, user1.active);
    println!("user2 name:{}, active:{}", user2.name, user2.active);
}
```

从上面示例可以看出，结构体更新语法的使用`..user1`，需要注意的是，必须要放在最后一行。表示未显示赋值的属性与user1中的属性相同。

结构体更新语法使用的也是=赋值，所以所有权规则在结构体中也是适用的，email属性值就被移动到user2中，其他类型是Copy特性类型所有为克隆并未移动。

## 6.2 没有属性名称的结构体：**元组结构体**

顾名思义这是一个元组结构体。

```rust
struct Color(i32, i32, i32);

fn main() {
    let black = Color(0, 0, 0);
    println!("{}", black.0);
}
```

## 6.3 没有任何属性的结构体：**类单元结构体**

这很类似元组中的单元元组，内部无任何值。

```rust
struct Tag;

fn main() {
    let tag = Tag;
}
```

4. 结构体实例，计算长方形面积

```rust
struct Rectangle {
    length: u32,
    height: u32,
}

fn main() {
    let r1 = Rectangle {
        length: 100,
        height: 40,
    };

    let area = area(&r1);

    println!("length:{}, height:{}, area:{}", r1.length, r1.height, area)
}

fn area(r: &Rectangle) -> u32 {
    r.length * r.height
}
```

以上示例就是结构体的使用，但是有几个技巧需要添加，可进一步优化代码，比如结构体实例内容显示不能直接显示。需要添加一些标识才可。

```rust
#[derive(Debug)]
struct Rectangle {
    length: u32,
    height: u32,
}

fn main() {
    let r1 = Rectangle {
        length: 100,
        height: 40,
    };

    let area = area(&r1);

    dbg!("{:?}, area:{}", r1, area);
}

fn area(r: &Rectangle) -> u32 {
    r.length * r.height
}
```

结构体上添加`#[derive(Debug)]`,然后在打印宏中使用`{:?}`或者`{:#?}`来显示。

## 6.4 方法

方法类似函数，只不过定义在impl代码块中，将它指向某个结构体。（很类似java中的类方法）

将计算面积方法放在结构体重：

```rust
#[derive(Debug)]
struct Rectangle {
    length: u32,
    height: u32,
}

impl Rectangle {
    fn area(&self) -> u32 {
        self.length * self.height
    }
}

fn main() {
    let r1 = Rectangle {
        length: 100,
        height: 40,
    };

    let area = r1.area();

    println!("{:?}, area:{}", r1, area);
}
```

这看上去和直接创建一个函数没什么大的区别，但是在理解上或阅读上是比较优雅的，并且这里会有一个隐藏参数即实例本身`&self`，调用方法时可以不用传参。

**关联函数**：同方法一样，只不过方法第一个参数不是self（类似java中的静态方法，属于类，关联函数也是）。

```rust
#[derive(Debug)]
struct Rectangle {
    length: u32,
    height: u32,
}

impl Rectangle {
    fn area(&self) -> u32 {
        self.length * self.height
    }
}

impl Rectangle {
    fn new(l: u32, h: u32) -> Self {
        Self {
            length: l,
            height: h,
        }
    }
}

fn main() {
    let r1 = Rectangle::new(100, 30);

    let area = r1.area();

    println!("{:?}, area:{}", r1, area);
}
```

以上示例看上去更像面向对象编程了，可以看到调用关联函数使用`::`。

**可以使用多个`impl`块，Self类型表示当前结构体类型。**

# 7. 枚举和匹配模式

## 7.1 枚举

1. 定义枚举

枚举类似结构体定义，关键字使用`enum`，调用使用`::`。

```rust
enum IpProtocol {
    IPv4,
    IPv6
}

fn main() {
    let ipv4 = IpProtocol::IPv4;
}
```

较为复杂的枚举：

```rust
#[derive(Debug)]
enum Message {
    Tag,
    Writer(String),
    Color(i32, i32, i32),
    Test {
        x: u32,
        y: u32,
    },
}

impl Message {
    fn call(&self) {
        println!("{:?}", self)
    }
}

fn main() {
    let e = Message::Test { x: 10, y: 3 };
    e.call();
}
```

在定义枚举中，它的内部属性：

- `Tag`：单元结构体
- `Writer(String)`：元组结构体
- `Color(i32, i32, i32),`：元组结构体
- `Test {...}`：结构体

2. Option枚举

这是一个基础库提供的枚举，主要是用于解决空值问题。在其他语言中可能会出现null来表示空值，但是空值的变量使用很容易超出预期。所有Rust中并没有null，取而代之的是Option枚举。

```rust
enum Option<T> {
    None,
    Some(T),
}
```

## 7.2 match 控制流程

这是通过匹配来控制流程的语法，可以它获得枚举中的值。

```rust
#[derive(Debug)]
enum Sex {
    Male(u8),
    Female(u8),
}

#[derive(Debug)]
struct People {
    age: u8,
    sex: String,
}

fn main() {
    let sex = Sex::Male(18);
    let p = match sex {
        Sex::Male(i) => People { age: i, sex: String::from("male") },
        Sex::Female(i) => {
            People { age: i, sex: String::from("female") }
        }
    };

    println!("{:?}", p)
}
```

**match使用规则**：

- match匹配是穷举的，所有要保证例出所有情况，也可以使用`other`或`_`来表示其他所有情况，**必须放在最后面**。
    - other：表示匹配其他所有情况，同时还需要使用这个值
    - _：表示匹配其他所有情况，但是不使用被匹配到的值（其他情况不作任何处理`_ => ()`）

## 7.3 if let 控制流程

当我们只关注匹配中的一个结果其他的不在意，这时在使用match就会显得代码很冗余。这时可以使用`if let`或`if let else`。可以把`if let`看成match的语法糖。

```rust
fn main() {
    let age = Some(5);
    if let Some(i) = age {
        println!("age:{}", i);
    } else {
        println!("未能获得年龄");
    }
}
```

从上面可以看出，else类似_或other匹配其他所有情况。if let会导致match**穷尽性检测被破坏**，所以使用if let需要在**简洁和穷尽**之间做出选择。

# 8. 包、Crate和模块

这是很令我头疼的一部分知识，一是这是新知识，二与我所熟悉的java包完全不同，先入为主的我会觉得这也太绕了太复杂了。

让我们来认识认识这令人头疼的概念：

- 包：包是提供一系列功能的一个crate或多个crate。
- crate：编译时最小单位，主要分为两种，二进制项目和库项目，可以包含多个模块。（主入口文件及主文件'引用'的代码）
- 模块：很类似java中类，可以在同一个文件中，也可以是单个文件。

## 8，1 定义包、Crate和模块

在Rust中关于包、Crate和模块的相关概念：

- 从crate根节点开始：当编译crate时，编译器会首先在根文件（二进制项目是main.rs，库项目则是lib.rs）中查找需要被编译的代码。
- 声明模块：你可以在根文件中声明一个新的模块`mod garden`，编译器会在声明后大括号中查找（如果声明后不是分号而是大括号）或`src/garden.rs`或`src/garden/mod.rs`。
- 声明子模块：与声明模块一样，不同的是声明不在根文件中。
- 模块中的代码路径：一个模块是你crate中的一部分，在访问权限运行的前提下，你可以在任意一个地方使用它。
- 私有和公有：默认所有属性，变量，结构体，枚举和模块都是私有的，可以通过添加`pub`来设置公有权限。
- use关键字：减少路径的重复使用，去掉冗余部分（类似java中impl，添加后就可以直接使用，无需添加路径前缀）。

简单的多模块例子：

main.rs

```rust
mod people;

use crate::people::student::Student;

fn main() {
    // 通过模块方法生成一个Student类实例
    let s = Student::new(String::from("fish"), 18, 'm', String::from("一年级二班"));
    println!("{:?}", s)
}
```

people.rs

```rust
pub mod student;
```

student.rs

```rust
#[derive(Debug)]
pub struct Student {
    name: String,
    age: u8,
    sex: char,
    class: String,
}

impl Student {
    pub fn new(name: String, age: u8, sex: char, class: String) -> Self {
        Self {
            name,
            age,
            sex,
            class,
        }
    }
}
```

文件路径示意图：

HelloRust ├── Cargo.lock ├── Cargo.toml └── src ├── people │ └── student.rs ├── people.rs └── main.rs

真不容易我能简单的理解，记得需要添加pub，rust默认全部是私有的。

模块是可以被嵌套的，以下示例可以看出（在同一个文件中举例），也可以理解为模块分组：

```rust
// 动物
mod animal {
    // 会飞的动物
    pub mod fly {
        pub fn fly_go() {
            println!("我会飞");
        }
    }

    // 会跑的动物
    pub mod run {
        pub fn run_go() {
            println!("我会跑");
        }
    }
}

// 相对路径
use animal::run::run_go;

// 绝对路径
use crate::animal::fly::fly_go;

fn main() {
    run_go();
    fly_go();
}
```

关于引用路径，还可以使用`super`关键字来表示从父目录开始。

## 8.2 use的使用

在前面的示例中我们以及开始使用use来解决重复路径问题，但是这也造成出现其他问题：模块名相同，不知道被调用代码出处。

一般use路径到被调代码的父类即可，例如我们使用student下的count方法时，我们use到student即可。通过`student::count()`来调用，这也解决同名问题。

还可以通过使用as为use导入进来的代码起一个别名来进行区分。例如`use crate::people::student::Stdeutn as PeopleStudent`。


> pub use重导出

将其他模块通过use导入到自己代码中，别人如果也需要调用它时，就必须重新使用老路径。通过pub use将代码变为自己的一部分，并对外暴露。

> use的嵌套

```rust
use std::cmp::Ordering;
use std::io;
// 可以改为如下
use std::{cmp::Ordering, io};


use std::io;
use std::io::Write;
// 可以修改成如下情况
use std::{Self, Write};

```

> 将所有的公有定义导入当前作用域，使用通配符*
```rust
use std::collection::*;
```

# 9. 常见集合

## 9.1 Vector

1. 新建Vector

新建空Vector集合：`let v: Vec<i32> = Vector::new();`

使用`vec!`宏来创建Vector集合：`let v = vec![1,2,3,4];`

2. 更新Vector

```rust
fn main() {
  let mut v = vec![1, 2];
  v.push(3);
}
```

3. 读取Vector的值
```rust
fn main() {
  let v = vec![1, 2, 3, 4];
  // 使用索引读取
  let one = &v[0];
  // 使用get获得一个Option
  let one_option = v.get(0);
}
```
两者的区别：
- 索引：当越界的时候就会导致程序直接报错结束。
- get方法：返回的是option，所以不会报错，看调用者如何处理错误。

4. 关于集合取值所有权问题

如下执行就会报错：
```rust
fn main() {
  let v = vec![1, 2, 3, 4];

  let one = &v[0];

  v.push(5);
}
```

出现这种情况的原因是，当vec集合空间不足时，就会重新获得一个更大的存储空间，将原数据移动过去，这就导致原指向数据地址的数据不可用。Rust是不允许出现这种情况的，借用检查器会进行所有权规则检查。

5. 遍历集合

以下示例，遍历并修改值：
```rust
fn main() {
  let v = vec![1, 2, 3, 4];
  for item in &mut v{
    // 这里需要使用解引用才能进行值的修改
    *item += 50;
  }
}
```

6. 存储多种类型

Vector是只能存储一种类型数据，但使用的是枚举类型，就可以达到存储多类型效果。

```rust
enum Animal {
  // 单元结构体
  Pig,
  // 元组结构体
  Cat(String),
  // 元组结构体
  Dog(u8),
  // 结构体
  Chicken {
    age: u8,
    kg: f64,
  },
}

fn main() {
  let animal = vec![
    Animal::Pig,
    Animal::Dog(8),
    Animal::Chicken { age: 3, kg: 2.5 },
  ];

  for item in animal {
    match item {
      Animal::Pig => println!("thi is pig"),
      Animal::Dog(i) => println!("thi is dog:{}", i),
      Animal::Chicken { age, kg } => println!("this is chicken:{},{}", age, kg),
      _ => ()
    }
  };
}
```

## 9.2 字符串

在Rust中，只有一种字符串类型就是Slice str。

1. 新建字符串
```rust
fn main() {
  let s1 = String::new();
  let s2 = "Hello";
  let s3 = String::from("Hello");
}
```


2. 更新字符串
```rust
fn main() {
  let mut s = String::from("foo");
  s.push_str("bar");


  let mut s1 = String::from("foo");
  let s2 = "bar";
  s1.push_str(s2);// 不会获得s2所有权，即使没有传引用
  println!("s2 is {}", s2);
}
```

3. 使用+或format!拼接字符串
```rust
fn main() {
  let s1 = String::from("tic");
  let s2 = String::from("tac");
  let s3 = String::from("toe");
  let s = format!("{}-{}-{}", s1, s2, s3);
  println!("{}", s);
}
```

下面使用+来实现拼接，拼接后s1便无效。这是因为+底层类似使用了`fn add(self, s: &str) -> String {`方法。
```rust
fn main() {
    let s1 = String::from("tic");
    let s2 = String::from("tac");
    let s = s1 + &s2;
    println!("{}", s);
}
```

4. 令人头疼的字符串

Rust字符串使用的是UTF-8，所包含的语言字符机会比较多。字符串的内部是`Vec<u8>`实现的。

Rust是不支持直接通过索引来访问字符串内容的，这是因为不同的语言做占用的字节数不同，这样直接通过下标访问导致访问并不是真正的单个字符。

但是Rust也提供了一种使用向标的方式，就是字符串Slice str，例如`&str[0..4]`。这种访问的使用需要谨慎。


5. 字符串的遍历

字符串的遍历需要明确是字符还是字节遍历：
```rust
fn main() {
  let s1 = String::from("tic");
  for item in s1.chars() {
    println!("{}", item);
  };

  for item in s1.bytes() {
    println!("{}", item);
  };
}
```

## 9.3 Hash Map

1. 新建Hash Map

在标准库中是有实现HashMap的，但是需要手动引入。
```rust
use std::collections::HashMap;

fn main() {
  let mut scores = HashMap::new();

  // 新增值
  scores.insert("key", "val");

  println!("{}", scores.get("key").expect(""));
}
```

通过Vec转向HashMap：
```rust
use std::collections::HashMap;

fn main() {
  let x = vec![String::from("red"), String::from("blue")];
  let y = vec![20, 4];

  // 组合成HashMap
  let x1: HashMap<_, _> = x.into_iter().zip(y.into_iter()).collect();

  println!("{}", x1.get("red").expect(""));
}
```

2. 遍历值
```rust
use std::collections::HashMap;

fn main() {
    let x = vec![String::from("red"), String::from("blue")];
    let y = vec![20, 4];

    // 组合成HashMap
    let map: HashMap<_, _> = x.into_iter().zip(y.into_iter()).collect();

    // 使用遍历加匹配解构
    for (x, y) in &map {
        println!("{}={}", x, y);
    }
    let option = &map.get("red");
    // 通过get方法
    match option {
        Some(num) => println!("red={}", num),
        _ => ()
    }
}
```

3. 更新值

HashMap的键值只能是唯一的，当存入相同键值机会覆盖老值。
```rust
use std::collections::HashMap;

fn main() {
    // 组合成HashMap
    let mut map: HashMap<String, u8> = HashMap::new();

    map.insert(String::from("red"), 10);
    // 存入相同key的值，将覆盖原来值
    map.insert(String::from("red"), 20);

    println!("red={}", map.get("red").expect(""));
}
```

通过值存在与否创建更新值：
```rust
use std::collections::HashMap;

fn main() {
    // 组合成HashMap
    let mut map: HashMap<String, u8> = HashMap::new();

    map.insert(String::from("red"), 10);
    // 存入相同key的值，将覆盖原来值
    map.insert(String::from("red"), 20);

    // 当值不存在时存入指定值
    map.entry(String::from("red")).or_insert(50);
    map.entry(String::from("blue")).or_insert(50);

    println!("red={}", map.get("red").expect(""));
    println!("blue={}", map.get("blue").expect(""));
}
```

判断旧值情况进行更新：
```rust
use std::collections::HashMap;

fn main() {
    // 统计单词出现次数
    let x = "A B C A D K C";

    let mut y = HashMap::new();

    for x in x.split_whitespace() {
        let z = y.entry(x.to_string()).or_insert(0);
        // 解引用进行值修改
        *z += 1;
    }

    for (a, b) in y {
        println!("{}={}", a, b);
    }
}
```

# 10 错误处理
