//
//  ScenarioViewController.swift
//  CGDDemoSwift
//
//  Created by WhatsXie on 2017/12/28.
//  Copyright © 2017年 R.S. All rights reserved.
//

import UIKit
import Async

class Person {
    var age = 0
}

class ScenarioViewController: UIViewController {
    @IBOutlet weak var scenarioLabel: UILabel!
    var color = UIColor.red
    var detailTextString:String = ""
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        scenarioLabel.text = detailTextString
    }
    
    override func viewDidDisappear(_ animated: Bool) {
        super.viewDidDisappear(animated)
        print("\n------------------------------------\n----------View Did Disappear--------\n------------------------------------\n")
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    // MARK: Async 部分
    open func timeConsumingAsync () {
        // 耗时操作
        Async.background {
            print("A: This is run on the \(qos_class_self().description) (expected \(QOS_CLASS_BACKGROUND.description))")
            sleep(2)
        }.main {
            print("B: This is run on the \(qos_class_self().description) (expected \(qos_class_main().description)), after the previous block")
        }
        // ----------- 替换如下方法
        //        dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_BACKGROUND, 0), {
        //            println("This is run on the background queue")
        //
        //            dispatch_async(dispatch_get_main_queue(), {
        //                println("This is run on the main queue, after the previous block")
        //            })
        //        })
    }
    open func timeConsumingAsyncParallel() {
        // 串行耗时操作
        let backgroundBlock = Async.background {
            print("1.This is run on the first\(qos_class_self().description) (expected \(QOS_CLASS_BACKGROUND.description))")
            sleep(2)
            
            print("2.This is run on the second \(qos_class_self().description) (expected \(QOS_CLASS_BACKGROUND.description))")
            sleep(2)
        }
        
        // Run other code here...
        backgroundBlock.main {
            print("3.This is run on the \(qos_class_self().description) (expected \(qos_class_main().description)), after the previous block")
        }
    }
    open func timeConsumingAsyncSeries() {
        // 普通多线程加载
        let group = AsyncGroup()
        group.background {
            print("This is run on the background queue")
        }
        group.background {
            print("This is also run on the background queue in parallel")
        }
        group.wait()
        print("Both asynchronous blocks are complete")
        
        // 自定义多线程加载
//        // 并发耗时操作
//        Async.main {
//            sleep(4)
//            print("1.This is run on the \(qos_class_self().description) (expected \(qos_class_main().description))")
//            // Prints: "This is run on the Main (expected Main) count: 1 (expected 1)"
//        }.userInteractive {
//            print("2.1.This is run on the \(qos_class_self().description) (expected \(QOS_CLASS_USER_INTERACTIVE.description))")
//            print("2.2.This is run on the \(qos_class_self().description) (expected \(QOS_CLASS_USER_INTERACTIVE.description))")
//
//            // Prints: "This is run on the Main (expected Main) count: 2 (expected 2)"
//        }.userInitiated {
//            sleep(1)
//            print("3.1.This is run on the \(qos_class_self().description) (expected \(QOS_CLASS_USER_INITIATED.description)) ")
//            print("3.2.This is run on the \(qos_class_self().description) (expected \(QOS_CLASS_USER_INITIATED.description)) ")
//
//            // Prints: "This is run on the User Initiated (expected User Initiated) count: 3 (expected 3)"
//        }.utility {
//            sleep(7)
//            print("4.This is run on the \(qos_class_self().description) (expected \(QOS_CLASS_UTILITY.description)) ")
//            // Prints: "This is run on the Utility (expected Utility) count: 4 (expected 4)"
//        }.background {
//            sleep(4)
//            print("5.This is run on the \(qos_class_self().description) (expected \(QOS_CLASS_BACKGROUND.description)) ")
//            // Prints: "This is run on the User Interactive (expected User Interactive) count: 5 (expected 5)"
//        }
    }
    
    open func delayedAsync() {
        // 延时执行
        let seconds = 3.0
        Async.main(after: seconds) {
            print("Is called after 3 seconds")
        }.background(after: 6.0) {
            print("At least 3.0 seconds after previous block, and 6.0 after Async code is called")
        }
    }
    
    open func customThreadAsync(){
        // 自定义线程
        let customQueue = DispatchQueue(label: "CustomQueueLabel", attributes: [.concurrent])
        let otherCustomQueue = DispatchQueue(label: "OtherCustomQueueLabel")
        Async.custom(queue: customQueue) {
            print("Custom queue")
        }.custom(queue: otherCustomQueue) {
            print("Other custom queue")
        }
    }
    
    open func waitThreadAsync() {
        // 等待线程
        let block = Async.background {
            // Do stuff
            print("Do stuff")
        }
        
        // Do other stuff
        block.wait()
    }
    
    open func cancelThreadAsync() {
        // 取消没有启动的线程：
        let block1 = Async.background {
            // Heavy work
            for i in 0...1000 {
                print("A \(i)")
            }
        }
        let block2 = block1.background {
            print("B – shouldn't be reached, since cancelled")
        }
        Async.main {
            block1.cancel() // First block is _not_ cancelled
            block2.cancel() // Second block _is_ cancelled
        }
    }
    
    // MARK: 自定义用法-基础
    // 主线程需要子线程的处理结果
    open func asynchronousReturn() {
        view.backgroundColor = color
        GCDKit().handle(somethingLong: {
            let p = Person()
            p.age = 40
            print(Date(), p.age)
            sleep(2)
            return p
        }) { (p: Person) in
            print(Date(), p.age)
            self.view.backgroundColor = UIColor.green
        }
    }
    
    // 主线程不需要子线程的处理结果
    open func asynchronousUnreturn() {
        GCDKit().handle(somethingLong: {
            print("I'm Going..")
            sleep(5)
        }) {
            print("I'm Finished~")
        }
    }
    
    // MARK: 自定义用法-进阶
    // 并发遍历
    // 如果你需要更快的处理数据，可以用 concurrentPerform 让循环操作并发执行：
    open func concurrentTraversal() {
        let data = [1, 2, 3]
        var sum = 0
        
        // map 遍历执行
        GCDKit().map(data: data) { (ele: Int) in
            sleep(1)
            sum += ele
        }
        print(sum)
        
        // 注意：并发执行-数据不安全
        GCDKit().run(code: { (i) in
            sleep(1)
            sum += data[i]
        }, repeting: data.count)
        print(sum)
    }
    
    // 控制并发数
    // 有时我们需要并发处理一些任务，但是并不想同时开很多线程，GCD 并没有类似 NSOperation 最大并发数的概念，但可以借助信号量实现：
    open func concurrencyControl() {
        let semaphore = DispatchSemaphore(value: 3)
        let queue = DispatchQueue(label: "", qos: .default, attributes: .concurrent)
        
        queue.async {
            semaphore.wait()
            GCDKit().doSomething(label: "1", cost: 2, complete: {
                print(Thread.current)
                semaphore.signal()
            })
        }
        queue.async {
            semaphore.wait()
            GCDKit().doSomething(label: "2", cost: 2, complete: {
                print(Thread.current)
                semaphore.signal()
            })
        }
        queue.async {
            semaphore.wait()
            GCDKit().doSomething(label: "3", cost: 4, complete: {
                print(Thread.current)
                semaphore.signal()
            })
        }
        queue.async {
            semaphore.wait()
            GCDKit().doSomething(label: "4", cost: 2, complete: {
                print(Thread.current)
                semaphore.signal()
            })
        }
        queue.async {
            semaphore.wait()
            GCDKit().doSomething(label: "5", cost: 3, complete: {
                print(Thread.current)
                semaphore.signal()
            })
        }
    }
    
    // 在子线程可开线程的情况下，依次执行需要借助信号量控制：
    open func nextNetworkRun() {
        let semaphore = DispatchSemaphore(value: 1)
        let queue = DispatchQueue(label: "", qos: .default, attributes: .concurrent)
        queue.async {
            semaphore.wait()
            self.networkTask(label: "1", cost: 2, complete: {
                semaphore.signal()
            })
            semaphore.wait()
            self.networkTask(label: "2", cost: 4, complete: {
                semaphore.signal()
            })
            semaphore.wait()
            self.networkTask(label: "3", cost: 3, complete: {
                semaphore.signal()
            })
            semaphore.wait()
            self.networkTask(label: "4", cost: 1, complete: {
                semaphore.signal()
            })
            semaphore.wait()
            print("all done")
            semaphore.signal()
        }
    }
    
    /*
     子任务内开线程不依次执行
     这种情况多见于需要请求多个接口，全部请求完毕后再进行某些操作，这可以借助 GCD 的任务组处理：
     */
    open func mixNetworkNextRun() {
        // 方法一：直接实现
        //        let group = DispatchGroup()
        //        group.enter()
        //        networkTask(label: "1", cost: 2, complete: {
        //            group.leave()
        //        })
        //        group.enter()
        //        networkTask(label: "2", cost: 4, complete: {
        //            group.leave()
        //        })
        //        group.enter()
        //        networkTask(label: "3", cost: 2, complete: {
        //            group.leave()
        //        })
        //        group.enter()
        //        networkTask(label: "4", cost: 4, complete: {
        //            group.leave()
        //        })
        //        group.notify(queue: .main, execute:{
        //            print("All network is done")
        //        })
        
        // 方法二：简写实现
        let downloadGroup = DispatchGroup()
        GCDKit().run(code: { (i) in
            downloadGroup.enter()
            networkTask(label: "\(i)", cost: UInt32(i), complete: {
                downloadGroup.leave()
            })
        }, repeting: 10)
        downloadGroup.notify(queue: .main) {
            print("All network is done")
        }
    }
}
/*
 子任务内开线程依次执行
 一般见于网络请求，一个接口的请求参数是另一个接口的返回值，这种情况就需要对网络请求进行时序管理，以下代码表示一个网络请求的封装：
 */
extension ScenarioViewController {
    private func networkTask(label:String, cost:UInt32, complete:@escaping ()->()){
        NSLog("Start network Task task%@",label)
        DispatchQueue.global().async {
            sleep(cost)
            NSLog("End networkTask task%@",label)
            DispatchQueue.main.async {
                complete()
            }
        }
    }
}

