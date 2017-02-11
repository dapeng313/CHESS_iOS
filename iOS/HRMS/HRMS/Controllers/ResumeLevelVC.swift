//
//  ResumeLevelVC.swift
//  HRMS
//
//  Created by Apollo on 1/23/17.
//  Copyright © 2017 Apollo. All rights reserved.
//

import UIKit
import SVProgressHUD

class ResumeLevelVC: BaseResumeInfoVC {

    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        tableView.delegate = self
        tableView.dataSource = self
        
        self.view.addSubview(self.tableView)
    }
    
    override func loadInfo() {
        
        SVProgressHUD.show()
        HRMSApi.POST(API_TITLE_INFO, params: ["PERNR": self.memberId!]) { (levelInfoResponse: LevelInfoResponse?, error: HRMSError?) in
            SVProgressHUD.dismiss()
            
            guard levelInfoResponse != nil else {
                SVProgressHUD.showError(withStatus: error?.message)
                return
            }
            
            if levelInfoResponse?.success == -1 {
                SVProgressHUD.showError(withStatus: "失败.")
                return
            }
            
            let levels = levelInfoResponse?.levels //as [levelInfo]?
            let paramList = levelInfoResponse?.paramList //as levelParams?
            
            for level in levels! {
                
                var paramHqflv: String?
                for param in (paramList?.par010)! as [ParamModel]{
                    if param.value == level.hqflv {
                        paramHqflv = param.name
                    }
                }
                
                let items = [
                    SectionItem(key: "职业资格类型", keyTitle: "职业资格类型:", value: throwEmpty(level.qftyp)!),
                    SectionItem(key: "资格等级", keyTitle: "资 格 等 级:", value: throwEmpty(level.qflvl)!),
                    SectionItem(key: "发证单位", keyTitle: "发 证 单 位:", value: throwEmpty(level.ctunt)!),
                    SectionItem(key: "证书编号", keyTitle: "证 书 编 号:", value: throwEmpty(level.ctnum)!),
                    SectionItem(key: "发证时间", keyTitle: "发 证 时 间:", value: throwEmpty(level.ctdat)!),
                    SectionItem(key: "是否最高等级", keyTitle: "是否最高等级:", value: throwEmpty(level.ctdat)!)
                ]
                self.sections.append(SectionInfo(name: throwEmpty(level.qftyp)!, items: items))
                
            }
            
            self.tableView.reloadData()
        }
    }
}
