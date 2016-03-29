# promise
promise A+ 规范的简单实现

### 1. 使用

点击 [这里](https://github.com/JackieLin/promise/blob/master/promise.js "下载") 下载，可以通过两种方式引入：

    1. 创建 script 标签 <script src="<Your path>/promise.js"></script>
    2. 通过 requirejs 等支持 AMD 规范的库引入

### 2. 语法
    // 新建
    promise = new Promise(function(resolve, reject) {
      return window.setTimeout(function() {
        return resolve(111);
      }, 1000);
    });
    
    // then
    promise.then(function(res) {
      return 333;
    }).then(function(res) {
        // 执行方法体
    });
    
    // then 返回 promise
    promise.then(function(res) {
      return new Promise(function(resolve, reject) {
        window.setTimeout(function() {
          resolve(222);
        }, 500);
      }).done(function(res) {
        // done 方法必须写，否则 promise 不会返回
        return res;
      });
    }).then(function(res) {
      return res;
    });
    
    // then fail
    new Promise(function(resolve, reject) {
      reject('error');
    }).fail(function(res) {
      console.log(res);
    });
    
### 3. 协议
promise 采用 **MIT** 协议
