# 1. Servlet生命周期

1. servlet第一次被调用调用`init()`方法
2. 调用`service()`方法来处理用户的请求
3. 销毁前调用`destory()`方法
4. 等待jvm自动销毁

# 2. 常用类
## 2.1 HttpServletRequest

请求连接：`http://localhost:8080/BookManager/category/add`

|方法|结果||
|---|---|---|
|getAuthType()|null||
|getAttributeNames()|java.util.Collections$3@67629391||
|getContextPath()|/BookManager||
|getCookies()|[Ljavax.servlet.http.Cookie;@2e72561c||
|getCharacterEncoding()|UTF-8||
|getContentLength()|38||
|getContentLengthLong()|38||
|getContentType()|application/x-www-form-urlencoded; charset=UTF-8||
|getDispatcherType()|REQUEST||
|getHeader(Cookie)|JSESSIONID=7A2577630EED7810C180EFB5C54A692E; Idea-6cb5bb4a=aad820ae-79ad-49f3-afdf-dcce86e13527; Hm_lvt_848509279e61c46d203b146e0022638c=1664332795; _ga=GA1.1.2108368523.1664332795||
|getHeaderNames()|org.apache.tomcat.util.http.NamesEnumerator@582bf277||
|getHeaders(Cookie)|org.apache.tomcat.util.http.ValuesEnumerator@33c570b4||
|getIntHeader(DNT)|1||
|getLocalAddr()|0:0:0:0:0:0:0:1||
|getLocale()|zh_CN||
|getLocales()|java.util.Collections$3@182f6617||
|getLocalPort()|8080||
|getLocalName()|localhost||
|getMethod()|POST||
|getParameter(name)|网络||
|getPathInfo()|/add||
|getProtocol()|HTTP/1.1||
|getParameterValues(name)|[Ljava.lang.String;@7877b1ee||
|getParameterNames()|java.util.Collections$3@3b20ed80||
|getPathTranslated()|/Users/yujiangzhong/IdeaProjects/Java/BookManager/target/BookManager/add||
|getParameterMap()|org.apache.catalina.util.ParameterMap@68e96114||
|getQueryString()|null||
|getRequestURI()|/BookManager/category/add||
|getRequestURL()|http://localhost:8080/BookManager/category/add||
|getRemoteHost()|0:0:0:0:0:0:0:1||
|getRemoteAddr()|0:0:0:0:0:0:0:1||
|getRemotePort()|59128||
|getRemoteUser()|null||
|getRequestedSessionId()|7A2577630EED7810C180EFB5C54A692E||
|getServletPath()|/category||
|getServerName()|localhost||
|getSession()|org.apache.catalina.session.StandardSessionFacade@2e96037||
|getServletContext()|org.apache.catalina.core.ApplicationContextFacade@29bf842d||
|getServerPort()|8080||
|getScheme()|http||
|getUserPrincipal()|null||
