//
//  GCDKit.swift
//  CGDDemoSwift
//
//  Created by WhatsXie on 2017/12/21.
//  Copyright © 2017年 R.S. All rights reserved.
//

import UIKit

class GCDKit: NSObject {
    let mainQueue = DispatchQueue.main
    let globalQueue = DispatchQueue(label: "globalQueue")
    
    /// 主线程需要子线程的处理结果
    func handle<T>(somethingLong: @escaping () -> T, finshed: @escaping (T) -> ()) {
        globalQueue.async {
            let data = somethingLong()
            self.mainQueue.async {
                finshed(data)
            }
        }
    }
    /// 主线程不需要子线程的处理结果
    func handle(somethingLong: @escaping () -> (), finshed: @escaping () -> ()) {
        let workItem = DispatchWorkItem {
            somethingLong()
        }
        globalQueue.async(execute: workItem)
        workItem.wait()
        finshed()
    }
}

// 如果你需要更快的处理数据，可以用 concurrentPerform 让循环操作并发执行：
extension GCDKit {
    /// 并发遍历
    func map<T>(data: [T], code: (T) -> ()) {
        DispatchQueue.concurrentPerform(iterations: data.count) { (i) in
            code(data[i])
        }
    }
    func run(code: (Int) -> (), repeting: Int) {
        DispatchQueue.concurrentPerform(iterations: repeting) { (i) in
            code(i)
        }
    }
}

// 有时我们需要并发处理一些任务，但是并不想同时开很多线程，GCD 并没有类似 NSOperation 最大并发数的概念，但可以借助信号量实现：
extension GCDKit {
    /// 控制并发数
    func doSomething(label: String, cost: UInt32, complete:@escaping ()->()){
        NSLog("Start task%@",label)
        sleep(cost)
        NSLog("End task%@",label)
        complete()
    }
}
