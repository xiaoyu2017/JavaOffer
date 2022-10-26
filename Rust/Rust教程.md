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
fn main(){
    println!("main run");
    
    a_function();
}

fn a_function(){
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

在rust中语句和表达式是有严格界限的，语句是没有返回值，表达式是有返回值的。例如`let x = 5;`这就是语句，而`x + y`是表达式。这样就与其他语言有了
不同，例如`x = y = 5` 在rust中是不成立的。

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
fn main(){
    let num = 10;
    if num < 100{
        println!("num < 100");
    }else{
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
fn main(){
    loop{
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
fn main(){
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
fn main(){
    let a = [1, 2, 3, 4, 5, 6];
    for item in a {
        println!("show array num: {}", item);
    };
    println!("for end...");
}
```

指定下标显示集合内容
```rust
fn main(){
    for item in 0..6{
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
fn main(){ // 值x是无效的，未声明 
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
    print!("s:{}",s);
}

fn show(str: &String){ // 借用s变量
    println!("借用内容：{}",str) // 进行操作
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
    print!("s:{}",s);
}

fn show(str: &String){ // 借用s变量
    str.push_str(" rust!"); // 这里编译不会通过，引用不可修改 
    println!("借用内容：{}",str) // 进行操作
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















