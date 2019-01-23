

![](https://www.travis-ci.org/ReverseScale/ThreadScenarioDemo.svg?branch=master) ![](https://img.shields.io/badge/platform-iOS-red.svg) ![](https://img.shields.io/badge/language-Swift-blue.svg) ![](https://img.shields.io/badge/download-9.9MB-yellow.svg) ![](https://img.shields.io/badge/license-MIT%20License-brightgreen.svg) 

[EN](https://github.com/ReverseScale/ThreadScenarioDemo) | [中文](https://github.com/ReverseScale/ThreadScenarioDemo/blob/master/README_zh.md)


使用 Async 帮你解决常见的线程问题 🤖

> 线程这种东西不是那么经常用得到，但是却很微观，很考察计算机基础功力。

![](https://user-gold-cdn.xitu.io/2018/3/12/1621845a78601b8d?w=637&h=379&f=png&s=267470)

----
## 🤖 要求

* iOS 9.0+
* Xcode 9.0+
* Swift 4

----
## 🎨 测试 UI 什么样子？

|1.展示页 |2.展示页 |3.展示页 |
| ------------- | ------------- | ------------- | 
| ![](https://user-gold-cdn.xitu.io/2018/3/15/16227c294d4ada05?w=358&h=704&f=png&s=60908) | ![](https://user-gold-cdn.xitu.io/2018/3/15/16227c2952da907c?w=358&h=704&f=png&s=45074) | ![](https://user-gold-cdn.xitu.io/2018/3/15/16227c2951fdff08?w=358&h=704&f=png&s=38121) | 
| 常见场景列表 | 耗时操作场景示例 | 黑科技操作场景示例 | 

----
## 🎯 安装方法

### 安装

在 *iOS*, 你需要在 Podfile 中添加.
```
source 'https://github.com/CocoaPods/Specs.git'
platform :ios, '9.0'
use_frameworks!

pod 'AsyncSwift'
```

----
## 🛠 配置

### 创建表单

#### 1.耗时操作

这是应用最广泛的场景，为了避免阻塞主线程，将耗时操作放在子线程处理，然后在主线程使用处理结果。比如读取沙盒中的一些数据，然后将读取的数据展示在 UI，这个场景还有几个细分：

#### 1.1 执行一个耗时操作后回调主线程
```Swift
Async.background {
print("A: This is run on the \(qos_class_self().description) (expected \(QOS_CLASS_BACKGROUND.description))")
    sleep(2)
}.main {
    print("B: This is run on the \(qos_class_self().description) (expected \(qos_class_main().description)), after the previous block")
}
```
#### 1.2 串行耗时操作

每一段子任务依赖上一个任务完成，全部完成后回调主线程：
```Swift
let backgroundBlock = Async.background {
    print("This is run on the first\(qos_class_self().description) (expected \(QOS_CLASS_BACKGROUND.description))")
    sleep(2)
    
    print("This is run on the second \(qos_class_self().description) (expected \(QOS_CLASS_BACKGROUND.description))")
    sleep(2)
}
// Run other code here...
backgroundBlock.main {
    print("This is run on the \(qos_class_self().description) (expected \(qos_class_main().description)), after the previous block")
}
```

#### 1.3 并发耗时操作

每一段子任务独立，所有子任务完成后回调主线程：
```Swift
Async.main {
    print("This is run on the \(qos_class_self().description) (expected \(qos_class_main().description))")
    // Prints: "This is run on the Main (expected Main) count: 1 (expected 1)"
    }.userInteractive {
        print("This is run on the \(qos_class_self().description) (expected \(QOS_CLASS_USER_INTERACTIVE.description))")
        // Prints: "This is run on the Main (expected Main) count: 2 (expected 2)"
    }.userInitiated {
        print("This is run on the \(qos_class_self().description) (expected \(QOS_CLASS_USER_INITIATED.description)) ")
        // Prints: "This is run on the User Initiated (expected User Initiated) count: 3 (expected 3)"
    }.utility {
        print("This is run on the \(qos_class_self().description) (expected \(QOS_CLASS_UTILITY.description)) ")
        // Prints: "This is run on the Utility (expected Utility) count: 4 (expected 4)"
    }.background {
        print("This is run on the \(qos_class_self().description) (expected \(QOS_CLASS_BACKGROUND.description)) ")
        // Prints: "This is run on the User Interactive (expected User Interactive) count: 5 (expected 5)"
}
```

#### 2.延时执行

延时一段时间后执行代码，一般见于打开 App 一段时间后，弹出求好评对话框。
```Swift
let seconds = 3.0
Async.main(after: seconds) {
    print("Is called after 3 seconds")
}.background(after: 6.0) {
    print("At least 3.0 seconds after previous block, and 6.0 after Async code is called")
}
```

其他用法请见 Demo。

### 😬 联系
* 微信 : WhatsXie
* 邮件 : ReverseScale@iCloud.com
* 博客 : https://reversescale.github.io
