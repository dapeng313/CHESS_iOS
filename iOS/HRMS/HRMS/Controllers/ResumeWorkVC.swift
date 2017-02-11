//
//  ResumeWorkVC.swift
//  HRMS
//
//  Created by Apollo on 1/23/17.
//  Copyright © 2017 Apollo. All rights reserved.
//

import UIKit
import SVProgressHUD

class ResumeWorkVC: BaseResumeInfoVC {

    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        tableView.delegate = self
        tableView.dataSource = self
        
        self.view.addSubview(self.tableView)
    }
    
    override func loadInfo() {
        
        SVProgressHUD.show()
        HRMSApi.POST(API_WORKEXP_INFO, params: ["PERNR": self.memberId!]) { (workInfoResponse: WorkInfoResponse?, error: HRMSError?) in
            SVProgressHUD.dismiss()
            
            guard workInfoResponse != nil else {
                SVProgressHUD.showError(withStatus: error?.message)
                return
            }
            
            if workInfoResponse?.success == -1 {
                SVProgressHUD.showError(withStatus: "失败.")
                return
            }
            
            let works = workInfoResponse?.works //as [WorkInfo]?
            let paramList = workInfoResponse?.paramList //as WorkParams?
            
            for work in works! {
                
                var paramUntur: String?
                for param in (paramList?.par025)! as [ParamModel]{
                    if param.value == work.untur {
                        paramUntur = param.name
                    }
                }
                
                let items = [
                    SectionItem(key: "单位名称", keyTitle: "单位名称:", value: throwEmpty(work.unnam)!),
                    SectionItem(key: "开始日期", keyTitle: "开始日期:", value: throwEmpty(work.begda)!),
                    SectionItem(key: "结束日期", keyTitle: "结束日期:", value: throwEmpty(work.endda)!),
                    SectionItem(key: "单位性质", keyTitle: "单位性质:", value: throwEmpty(work.unpos)!),
                    SectionItem(key: "岗位", keyTitle: "岗 位:", value: throwEmpty(paramUntur)!),
                    SectionItem(key: "工资", keyTitle: "工 资:", value: "-")
                ]
                self.sections.append(SectionInfo(name: throwEmpty(work.unnam)!, items: items))
                
            }
            
            self.tableView.reloadData()
        }
    }
}
