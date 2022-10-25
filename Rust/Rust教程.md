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

























