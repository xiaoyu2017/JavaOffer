# 脚手架步骤
1. 全局安装@vue/cli：`npm install -g @vue/cli`
2. 用命令创建项目：`vue create xxxx`
3. 启动项目：npm run serve

# ref与props
## ref
> 为标签做标记，然后通过this.$refs.xxx获得对象DOM

```html
<h1 v-text="msg" ref="title"></h1>
console.log(this.$refs.title)
```

## props
> 用于父组件给子组件传递数据

```html
<PropsItemTest name="fish" :age="18" sex="male"/>
<script>
    export default {
        name: "PropsTest",
        data() {
            return {
            }
        },
        // 简单接收
        // props:['name', 'age', 'sex']

        //接收的同时对数据进行类型限制
        /* props:{
          name:String,
          age:Number,
          sex:String
        } */

        //接收的同时对数据：进行类型限制+默认值的指定+必要性的限制
        props:{
            name:{
                type:String, //name的类型是字符串
                required:true, //name是必要的
            },
            age:{
                type:Number,
                default:99 //默认值
            },
            sex:{
                type:String,
                required:true
            }
        }
    }
</script>
```

# 混合mixin
混入 (mixin) 提供了一种非常灵活的方式，来分发 Vue 组件中的可复用功能。一个混入对象可以包含任意组件选项。当组件使用混入对象时，所有混入对象的选项将被“混合”进入该组件本身的选项。

创建mixin.js文件
```js
export const hunhe = {
    methods: {
        showName(){
            alert(this.name)
        }
    },
    mounted() {
        console.log('你好啊！')
    },
}
export const hunhe2 = {
    data() {
        return {
            x:100,
            y:200
        }
    },
}
```

全局注册：
```js
// 在main.js中注册
import {hunhe,hunhe2} from "@/mixin";
Vue.mixin(hunhe)
Vue.mixin(hunhe2)
```

局部注册：
```js
import {hunhe, hunhe2} from "@/mixin";
export default {
    name: 'MixinTest',
    data() {
        return {
            name: '张三',
            sex: '男'
        }
    },
    mixins: [hunhe, hunhe2]
}
```

# 插件Plugins
创建plugins.js
```js
export default {
    install(Vue,x,y,z){
        console.log(x,y,z)
        //全局过滤器
        Vue.filter('mySlice',function(value){
            return value.slice(0,4)
        })

        //定义全局指令
        Vue.directive('fbind',{
            //指令与元素成功绑定时（一上来）
            bind(element,binding){
                element.value = binding.value
            },
            //指令所在元素被插入页面时
            inserted(element){
                element.focus()
            },
            //指令所在的模板被重新解析时
            update(element,binding){
                element.value = binding.value
            }
        })

        //定义混入
        Vue.mixin({
            data() {
                return {
                    x:100,
                    y:200
                }
            },
        })

        //给Vue原型上添加一个方法（vm和vc就都能用了）
        Vue.prototype.hello = ()=>{alert('你好啊')}
    }
}
```

main.js注册plugins
```js
import plugins from "@/plugins";
Vue.use(plugins, 1, 2, 3)
```

使用
```html
<template>
  <div>
    <h2>学校名称：{{ name | mySlice }}</h2>
    <h2>学校地址：{{ address }}</h2>
    <button @click="test">点我测试一个hello方法</button>
    <hr>
  </div>
</template>
<script>
export default {
  name: 'PluginsTest',
  data() {
    return {
      name: 'ABCDEFGHI',
      address: '北京',
    }
  },
  methods: {
    test() {
      this.hello()
    }
  },
}
</script>
```

# scoped
实现组件的私有化，不对全局造成样式污染，表示当前style属性只属于当前模块。

# 自定义事件
1. 语法
```js
// 方法一
<CustomEvent1 @event1="show"/>
    
// 方法二
<CustomEvent2 ref="event2"/>
mounted() {
    this.$refs.event2.$on('event2',this.show)
}

// 调用
this.$emit('event1')
this.$emit('event2')
```

# 全局事件总线
```js
// 安装全局事件main.js
beforeCreate() {
    Vue.prototype.$bus = this //安装全局事件总线
}

// 创建事件
this.$bus.$on('hello', (data) => {
    console.log('我是App组件，收到了数据', data)
})

// 调用事件
this.$bus.$emit('hello',this.name)

// 解绑事件
this.$bus.$off('hello')
```

# 消息订阅与发布
与全局事件总线类似

下载依赖：`npm install -S pubsub-js`

```js
// 发布消息
this.pubId = PubSub.subscribe('helloPubsub', (msgName, data) => {
    console.log(msgName)
    console.log(data)
    console.log(this)
})

// 调用消息
PubSub.publish('helloPubsub', 666)

// 解绑
PubSub.unsubscribe(this.pubId)
```

# 插槽
```html
<SlotTest title="这是一">
  <h2>这是第一个使用插槽</h2>
</SlotTest>
<SlotTest title="这是二">
  <h2>这是第二个使用插槽</h2>
</SlotTest>
<SlotTest title="这是三">
  <h2>这是第三个使用插槽</h2>
</SlotTest>

<div>
    <h1 v-text="title"></h1>
    <!-- 占位符 -->
    <slot></slot>
</div>
```

