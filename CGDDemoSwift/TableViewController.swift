//
//  TableViewController.swift
//  CGDDemoSwift
//
//  Created by WhatsXie on 2017/12/28.
//  Copyright © 2017年 R.S. All rights reserved.
//

import UIKit

class TableViewController: UITableViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
}

extension TableViewController {
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let scenarioController = ScenarioViewController()
        switch (indexPath.section, indexPath.row) {
        case (0, 0):
            scenarioController.detailTextString = "这是应用最广泛的场景，为了避免阻塞主线程，将耗时操作放在子线程处理，然后在主线程使用处理结果。比如读取沙盒中的一些数据，然后将读取的数据展示在 UI，这个场景还有几个细分：\n\n 1.1 执行一个耗时操作后回调主线程：";
            scenarioController.timeConsumingAsync()
        case (0, 1):
            scenarioController.detailTextString = "这是应用最广泛的场景，为了避免阻塞主线程，将耗时操作放在子线程处理，然后在主线程使用处理结果。比如读取沙盒中的一些数据，然后将读取的数据展示在 UI，这个场景还有几个细分：\n\n 1.2 串行耗时操作 \n 每一段子任务依赖上一个任务完成，全部完成后回调主线程：";
            scenarioController.timeConsumingAsyncParallel()
        case (0, 2):
            scenarioController.detailTextString = "这是应用最广泛的场景，为了避免阻塞主线程，将耗时操作放在子线程处理，然后在主线程使用处理结果。比如读取沙盒中的一些数据，然后将读取的数据展示在 UI，这个场景还有几个细分：\n\n 1.3 并发耗时操作 \n 每一段子任务独立，所有子任务完成后回调主线程：";
            scenarioController.timeConsumingAsyncSeries()
        case (1, 0):
            scenarioController.detailTextString = "延时执行 \n\n 延时一段时间后执行代码，一般见于打开 App 一段时间后，弹出求好评对话框。";
            scenarioController.delayedAsync()
        case (1, 1):
            scenarioController.detailTextString = "自定义线程 \n\n 根据使用场景来自定义线程，更好的控制管理线程操作。";
            scenarioController.customThreadAsync()
        case (1, 2):
            scenarioController.detailTextString = "等待线程 \n\n 根据使用场景来等待 Block 中操作完成后执行线程。";
            scenarioController.waitThreadAsync()
        case (1, 3):
            scenarioController.detailTextString = "取消线程 \n\n 根据使用场景来取消未被启动的线程，更好的管理线程的“生命周期”。";
            scenarioController.cancelThreadAsync()
        case (2, 0):
            scenarioController.detailTextString = "并发遍历 \n\n 如果你需要更快的处理数据，可以用 concurrentPerform 让循环操作并发执行。";
            scenarioController.concurrentTraversal()
        case (2, 1):
            scenarioController.detailTextString = "控制并发数 \n\n 有时我们需要并发处理一些任务，但是并不想同时开很多线程，GCD 并没有类似 NSOperation 最大并发数的概念，但可以借助信号量实现。";
            scenarioController.concurrencyControl()
        case (2, 2):
            scenarioController.detailTextString = "权重优先级 \n\n 在子线程可开线程的情况下，依次执行需要借助信号量控制：";
            scenarioController.nextNetworkRun()
        case (2, 3):
            scenarioController.detailTextString = "子任务内开线程不依次执行 \n\n 这种情况多见于需要请求多个接口，全部请求完毕后再进行某些操作，这可以借助 GCD 的任务组处理：";
            scenarioController.mixNetworkNextRun()
        default:
            print("\n 没有被选中场景 \n")
        }
        
        navigationController?.pushViewController(scenarioController, animated: true)
    }
}
