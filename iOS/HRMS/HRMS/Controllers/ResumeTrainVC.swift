//
//  ResumeTrainVC.swift
//  HRMS
//
//  Created by Apollo on 1/23/17.
//  Copyright © 2017 Apollo. All rights reserved.
//

import UIKit
import SVProgressHUD

class ResumeTrainVC: BaseResumeInfoVC {

    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        tableView.delegate = self
        tableView.dataSource = self
        
        self.view.addSubview(self.tableView)
    }
    
    override func loadInfo() {
        
        SVProgressHUD.show()
        HRMSApi.POST(API_TRAIN_INFO, params: ["PERNR": self.memberId!]) { (trainInfoResponse: TrainInfoResponse?, error: HRMSError?) in
            SVProgressHUD.dismiss()
            
            guard trainInfoResponse != nil else {
                SVProgressHUD.showError(withStatus: error?.message)
                return
            }
            
            if trainInfoResponse?.success == -1 {
                SVProgressHUD.showError(withStatus: "失败.")
                return
            }
            
            let trains = trainInfoResponse?.trains //as [TrainInfo]?
            let paramList = trainInfoResponse?.paramList //as TrainParams?
            
            for train in trains! {
                
                var paramTrype: String?
                for param in (paramList?.par052)! as [ParamModel]{
                    if param.value == train.trype {
                        paramTrype = param.name
                    }
                }
                
                let items = [
                    SectionItem(key: "课程名称", keyTitle: "课程名称:", value: throwEmpty(train.couna)!),
                    SectionItem(key: "开始日期", keyTitle: "开始日期:", value: throwEmpty(train.begda)!),
                    SectionItem(key: "结束日期", keyTitle: "结束日期:", value: throwEmpty(train.endda)!),
                    SectionItem(key: "培训类型", keyTitle: "培训类型:", value: throwEmpty(paramTrype)!),
                    SectionItem(key: "培训结果", keyTitle: "培训结果:", value: throwEmpty(train.trrst)!),
                    SectionItem(key: "领导评价", keyTitle: "领导评价:", value: "-")
                ]
                self.sections.append(SectionInfo(name: throwEmpty(train.couna)!, items: items))
                
            }
            
            self.tableView.reloadData()
        }
    }
}
