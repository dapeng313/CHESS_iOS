//
//  ApprovalMenuVC.swift
//  HRMS
//
//  Created by Apollo on 2/3/17.
//  Copyright © 2017 Apollo. All rights reserved.
//

import UIKit

class ApprovalMenuVC: BaseSlideMenuVC {
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.headers = ["我的申请", "我的审批"]
        self.titles1 = ["草稿箱", "已申请", "已办理", "已通过", "全部流程", "已拒绝"]
        self.titles2 = ["待办流程", "已办理", "已完结", "全部流程"]
        self.icons1 = [UIImage(named: "folder")!, UIImage(named: "task_waiting")!, UIImage(named: "task_doing")!, UIImage(named: "task_done")!, UIImage(named: "new")!, UIImage(named: "task_evaluated")!]
        self.icons2 = [UIImage(named: "order_waiting")!, UIImage(named: "order_doing")!, UIImage(named: "order_done")!, UIImage(named: "order_evaluated")!]
        
        self.tableView.reloadData()
    }
    
    func newTask() {
        let vc = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "NewTaskVC")
        self.navigationController?.pushViewController(vc, animated: true)
    }
}
