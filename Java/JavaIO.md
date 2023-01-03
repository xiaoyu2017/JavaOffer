# 1. IO流分类
- 功能分：输入流和输出流
- 类型分：字节类和字符流

# 2. BIO、NIO、AIO区别

BIO：普通IO，并发能力不强
NIO：BIO升级版，基于通道多路复用进行通信
AIO：BIO升级版，采用事件和回调机制实现。

# 3. Files常用方法

|方法|说明|
|---|---|
|exists()|路径是否存在|
|createFile()|创建文件|
|createDirectory()|创建文件夹|
|delete()|删除文件|
|move()|移动文件|
|copy()|拷贝文件|