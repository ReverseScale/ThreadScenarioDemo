# ThreadScenarioDemo

![](https://img.shields.io/badge/platform-iOS-red.svg) ![](https://img.shields.io/badge/language-Swift-blue.svg) ![](https://img.shields.io/badge/download-9.9MB-yellow.svg) ![](https://img.shields.io/badge/license-MIT%20License-brightgreen.svg) ![](https://www.travis-ci.org/ReverseScale/ThreadScenarioDemo.svg?branch=master)

[EN](https://github.com/ReverseScale/ThreadScenarioDemo) | [中文](https://github.com/ReverseScale/ThreadScenarioDemo/blob/master/README_zh.md)

Use Async to help you solve common threading issues 🤖

![](https://user-gold-cdn.xitu.io/2018/3/12/1621845a78601b8d?w=637&h=379&f=png&s=267470)

> This kind of threading is not used so often, but it is very microscopic, and it examines the basic skills of the computer.

----
## 🤖 Requirements

* iOS 9.0+
* Xcode 9.0+
* Swift 4

----
## 🎨 Why test the UI?

|1.Presentation page | 2.Presentation page | 3.Presentation page |
| ------------- | ------------- | ------------- | 
| ![](https://user-gold-cdn.xitu.io/2018/3/15/16227c294d4ada05?w=358&h=704&f=png&s=60908) | ![](https://user-gold-cdn.xitu.io/2018/3/15/16227c2952da907c?w=358&h=704&f=png&s=45074) | ![](https://user-gold-cdn.xitu.io/2018/3/15/16227c2951fdff08?w=358&h=704&f=png&s=38121) | 
| Common Scene Lists | Time-Sample Operation Scenario Examples | Black Technology Operation Scenarios Example |

----
## 🎯 Installation

### Install

In *iOS*, you need to add in Podfile.
```
source 'https://github.com/CocoaPods/Specs.git'
platform :ios, '9.0'
use_frameworks!

pod 'AsyncSwift'
```

----
## 🛠 Configuration

### Create a form

#### 1. Time-consuming operation

This is the most widely used scenario. To avoid blocking the main thread, the time-consuming operation is handled by the child thread, and then the processing result is used in the main thread. For example, reading some of the data in the sandbox, and then displaying the read data in the UI, this scene has several subdivisions:

1.1 Callback to main thread after performing a time-consuming operation
```Swift
Async.background {
print("A: This is run on the \(qos_class_self().description) (expected \(QOS_CLASS_BACKGROUND.description))")
    sleep(2)
}.main {
    print("B: This is run on the \(qos_class_self().description) (expected \(qos_class_main().description)), after the previous block")
}
```

1.2 Serial Time-consuming Operation

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

1.3 Concurrency and Time-consuming Operations

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

#### 2. Delayed execution

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

## 😬 Contributions
* WeChat : WhatsXie
* Email : ReverseScale@iCloud.com
* Blog : https://reversescale.github.io

