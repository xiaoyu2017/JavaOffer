# vue-router
vue 的一个插件库，专门用来实现 SPA 应用。

# 基本使用

创建路由js文件（文件路径router/index.js）

```js
// 该文件专门用于创建整个应用的路由器
import VueRouter from 'Framework/Vue/vue-router'
//引入组件
import Home from "@/components/router/Home";
import About from "@/components/router/About";
//创建并暴露一个路由器
export default new VueRouter({
    routes: [
        {
            path: '/about',
            component: About
        },
        {
            path: '/home',
            component: Home
        }
    ]
})
```

入口注册路由
```js
//引入VueRouter
import VueRouter from 'vue-router'
//引入路由器
import router from './router'
//应用插件
Vue.use(VueRouter)
new Vue({
    render: h => h(App),
    beforeCreate() {
        Vue.prototype.$bus = this //安装全局事件总线
    },
    // 应用路由
    router: router
}).$mount('#app')
```

使用路由
```html
<!-- Vue中借助router-link标签实现路由的切换 -->
<router-link class="list-group-item" active-class="active" to="/about">About</router-link>
<router-link class="list-group-item" active-class="active" to="/home">Home</router-link>

<!-- 指定组件的呈现位置 -->
<router-view></router-view>
```

# 多级路由
```js
export default new VueRouter({
    routes: [
        {
            path: '/about',
            component: About
        },
        {
            path: '/home',
            component: Home,
            children: [
                {
                    path: 'news',
                    component: HomeNews,
                },
                {
                    path: 'message',
                    component: HomeTitle,
                }
            ]
        }
    ]
})
```

# 路由传参
```html
<li v-for="(m) in messageList" :key="m.id">
<!-- 跳转路由并携带query参数，to的字符串写法 -->
<!-- <router-link :to="`/home/message/detail?id=${m.id}&title=${m.title}`">{{m.title}}</router-link>&nbsp;&nbsp; -->

<!-- 跳转路由并携带query参数，to的对象写法 -->
<router-link :to="{
            path:'/msg/msgDetail',
            query:{
                id:m.id,
                title:m.title
            }
        }">
  {{m.title}}
</router-link>
</li>
```

# 路由命名
```js
const router = new VueRouter({
  routes: [
    {
      path: '/user/:userId',
      name: 'user',
      component: User
    }
  ]
})
```

```html
<router-link :to="{ name: 'user', params: { userId: 123 }}">User</router-link>
```

```js
router.push({ name: 'user', params: { userId: 123 } })
```

# 路由传参param
```html
<div>
    <h1>路由参数</h1>
    <ul>
        <li v-for="m in messageList" :key="m.id">
            <router-link :to="{ name: 'paramShow', params: { id: m.id,title:m.title }}">路由param-{{m.id}}</router-link>
        </li>
    </ul>

    <router-view></router-view>
</div>
```

```html
<div>
    <ul>
      <li>消息编号：{{ $route.params.id }}</li>
      <li>消息标题：{{ $route.params.title }}</li>
    </ul>
</div>
```

# 编程式路由
1. this.$router.push(path): 相当于点击路由链接(可以返回到当前路由界面) 
2. this.$router.replace(path): 用新路由替换当前路由(不可以返回到当前路由界面) 
3. this.$router.back(): 请求(返回)上一个记录路由 
4. this.$router.go(-1): 请求(返回)上一个记录路由 
5. this.$router.go(1): 请求下一个记录路由