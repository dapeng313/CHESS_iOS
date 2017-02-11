//
//  ResumeEducationVC.swift
//  HRMS
//
//  Created by Apollo on 1/23/17.
//  Copyright © 2017 Apollo. All rights reserved.
//

import UIKit
import SVProgressHUD

class ResumeEducationVC: BaseResumeInfoVC {

    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        tableView.delegate = self
        tableView.dataSource = self
        
        self.view.addSubview(self.tableView)
    }
    
    override func loadInfo() {
        
        SVProgressHUD.show()
        HRMSApi.POST(API_EDUCATION_INFO, params: ["PERNR": self.memberId!]) { (educationInfoResponse: EducationInfoResponse?, error: HRMSError?) in
            SVProgressHUD.dismiss()
            
            guard educationInfoResponse != nil else {
                SVProgressHUD.showError(withStatus: error?.message)
                return
            }
            
            if educationInfoResponse?.success == -1 {
                SVProgressHUD.showError(withStatus: "失败.")
                return
            }
            
            let educations = educationInfoResponse?.educations //as [EducationInfo]?
            let paramList = educationInfoResponse?.paramList //as EducationParams?
            
            for education in educations! {
                
                var paramEtype: String?
                for param in (paramList?.par013)! as [ParamModel]{
                    if param.value == education.etype {
                        paramEtype = param.name
                    }
                }
                
                let items = [
                    SectionItem(key: "教育类型", keyTitle: "教育类型:", value: throwEmpty(paramEtype)!),
                    SectionItem(key: "学位", keyTitle: "学 位:", value: throwEmpty(education.acdeg)!),
                    SectionItem(key: "开始日期", keyTitle: "开始日期:", value: throwEmpty(education.begda)!),
                    SectionItem(key: "毕业日期", keyTitle: "毕业日期:", value: throwEmpty(education.endda)!),
                    SectionItem(key: "专业1", keyTitle: "专 业 1:", value: throwEmpty(education.spec1)!),
                    SectionItem(key: "专业2", keyTitle: "专 业 2:", value: throwEmpty(education.spec2)!)
                ]
                self.sections.append(SectionInfo(name: throwEmpty(paramEtype)!, items: items))
                
            }

            self.tableView.reloadData()
        }
    }
}
