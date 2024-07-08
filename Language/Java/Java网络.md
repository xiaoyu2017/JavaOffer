# Socket

## Socket创建步骤
1. 服务端创建ServerSocket，指定端口号，并用accept等待客户端连接。
2. 客户端创建Socket，并与服务端建立连接。
3. 服务器接收客户的连接请求,并创建一个新的Socket与该客户建立专线连接。
4. 刚才建立了连接的两个Socket在一个线程上对话。
5. 服务器开始进行发送数据处理。
6. 关闭连接。

[Socket,Udp](https://github.com/xiaoyu2017/ExampleCode/tree/master/JavaExample/src/cn/fishland/example/socket)




