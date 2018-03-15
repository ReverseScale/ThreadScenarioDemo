# ThreadScenarioDemo

![](https://img.shields.io/badge/platform-iOS-red.svg) ![](https://img.shields.io/badge/language-Swift-blue.svg) ![](https://img.shields.io/badge/download-9.9MB-yellow.svg) ![](https://img.shields.io/badge/license-MIT%20License-brightgreen.svg) 

[EN](#Requirements) | [中文](#中文说明)

Use Async to help you solve common threading issues 🤖

![](http://og1yl0w9z.bkt.clouddn.com/17-12-28/7998417.jpg)

> This kind of threading is not used so often, but it is very microscopic, and it examines the basic skills of the computer.

----
### 🤖 Requirements

* iOS 9.0+
* Xcode 9.0+
* Swift 4

----
### 🎨 Why test the UI?

|1.Presentation page | 2.Presentation page | 3.Presentation page |
| ------------- | ------------- | ------------- | 
| ![](http://og1yl0w9z.bkt.clouddn.com/18-3-15/34884761.jpg) | ![](http://og1yl0w9z.bkt.clouddn.com/18-3-15/77175469.jpg) | ![](http://og1yl0w9z.bkt.clouddn.com/18-3-15/60412728.jpg) | 
| Common Scene Lists | Time-Sample Operation Scenario Examples | Black Technology Operation Scenarios Example |

----
### 🎯 Installation

#### Install

In *iOS*, you need to add in Podfile.
```
source 'https://github.com/CocoaPods/Specs.git'
platform :ios, '9.0'
use_frameworks!

pod 'AsyncSwift'
```

----
### 🛠 Configuration

#### Create a form

1. Time-consuming operation

This is the most widely used scenario. To avoid blocking the main thread, the time-consuming operation is handled by the child thread, and then the processing result is used in the main thread. For example, reading some of the data in the sandbox, and then displaying the read data in the UI, this scene has several subdivisions:
*1.1 Callback to main thread after performing a time-consuming operation
```Swift
Async.background {
print("A: This is run on the \(qos_class_self().description) (expected \(QOS_CLASS_BACKGROUND.description))")
    sleep(2)
}.main {
    print("B: This is run on the \(qos_class_self().description) (expected \(qos_class_main().description)), after the previous block")
}
```
*1.2 Serial Time-consuming Operation*

Each sub-task depends on the last task completed, and it will call back the main thread after it completes:
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
*1.3 Concurrency and Time-consuming Operations*

Each subtask is independent, and the main thread is called back after all subtasks are completed:
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

2. Delayed execution

Execution of code after a period of delay, generally found after opening the App for a period of time, pop-up praise dialog.
```Swift
let seconds = 3.0
Async.main(after: seconds) {
    print("Is called after 3 seconds")
}.background(after: 6.0) {
    print("At least 3.0 seconds after previous block, and 6.0 after Async code is called")
}
```

For other usages, see Demo.

----
### ⚖ License

```
MIT License

Copyright (c) 2017 ReverseScale

Permission is hereby granted, free of charge, to any person obtaining a copy
of this software and associated documentation files (the "Software"), to deal
in the Software without restriction, including without limitation the rights
to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
copies of the Software, and to permit persons to whom the Software is
furnished to do so, subject to the following conditions:

The above copyright notice and this permission notice shall be included in all
copies or substantial portions of the Software.

THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE
SOFTWARE.
```

### 😬 Contributions
* WeChat : WhatsXie
* Email : ReverseScale@iCloud.com
* Blog : https://reversescale.github.io

---
#中文说明

使用 Async 帮你解决常见的线程问题 🤖

> 线程这种东西不是那么经常用得到，但是却很微观，很考察计算机基础功力。

![](http://og1yl0w9z.bkt.clouddn.com/17-12-28/7998417.jpg)

----
### 🤖 要求

* iOS 9.0+
* Xcode 9.0+
* Swift 4

----
### 🎨 测试 UI 什么样子？

|1.展示页 |2.展示页 |3.展示页 |
| ------------- | ------------- | ------------- | 
| ![](http://og1yl0w9z.bkt.clouddn.com/18-3-15/34884761.jpg) | ![](http://og1yl0w9z.bkt.clouddn.com/18-3-15/77175469.jpg) | ![](http://og1yl0w9z.bkt.clouddn.com/18-3-15/60412728.jpg) | 
| 常见场景列表 | 耗时操作场景示例 | 黑科技操作场景示例 | 

----
### 🎯 安装方法

#### 安装

在 *iOS*, 你需要在 Podfile 中添加.
```
source 'https://github.com/CocoaPods/Specs.git'
platform :ios, '9.0'
use_frameworks!

pod 'AsyncSwift'
```

----
### 🛠 配置

#### 创建表单

1.耗时操作

这是应用最广泛的场景，为了避免阻塞主线程，将耗时操作放在子线程处理，然后在主线程使用处理结果。比如读取沙盒中的一些数据，然后将读取的数据展示在 UI，这个场景还有几个细分：
*1.1 执行一个耗时操作后回调主线程*
```Swift
Async.background {
print("A: This is run on the \(qos_class_self().description) (expected \(QOS_CLASS_BACKGROUND.description))")
    sleep(2)
}.main {
    print("B: This is run on the \(qos_class_self().description) (expected \(qos_class_main().description)), after the previous block")
}
```
*1.2 串行耗时操作*

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
*1.3 并发耗时操作*

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

2.延时执行

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

----
### ⚖ 协议

```
MIT License

Copyright (c) 2017 ReverseScale

Permission is hereby granted, free of charge, to any person obtaining a copy
of this software and associated documentation files (the "Software"), to deal
in the Software without restriction, including without limitation the rights
to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
copies of the Software, and to permit persons to whom the Software is
furnished to do so, subject to the following conditions:

The above copyright notice and this permission notice shall be included in all
copies or substantial portions of the Software.

THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE
SOFTWARE.
```

### 😬 联系
* 微信 : WhatsXie
* 邮件 : ReverseScale@iCloud.com
* 博客 : https://reversescale.github.io
