//
//  TaskSlideMenu.swift
//  HRMS
//
//  Created by Apollo on 2/2/17.
//  Copyright © 2017 Apollo. All rights reserved.
//

import UIKit

class TaskMenuVC: BaseSlideMenuVC {
    
    
    override func viewDidLoad() {
        super.viewDidLoad()

        self.headers = ["我的任务", "我的下达"]
        self.titles1 = ["待完成", "进行中", "已完成", "已评估"]
        self.titles2 = ["待接收", "进行中", "待评估", "已评估"]
        self.icons1 = [UIImage(named: "task_waiting")!, UIImage(named: "task_doing")!, UIImage(named: "task_done")!, UIImage(named: "task_evaluated")!]
        self.icons2 = [UIImage(named: "order_waiting")!, UIImage(named: "order_doing")!, UIImage(named: "order_done")!, UIImage(named: "order_evaluated")!]

        self.tableView.reloadData()
    }
    
    func newTask() {
        let vc = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "NewTaskVC")
        self.navigationController?.pushViewController(vc, animated: true)
    }
}
