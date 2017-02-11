//
//  ResumeEventVC.swift
//  HRMS
//
//  Created by Apollo on 1/23/17.
//  Copyright © 2017 Apollo. All rights reserved.
//

import UIKit
import SVProgressHUD

class ResumeEventVC: BaseResumeInfoVC {

    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        tableView.delegate = self
        tableView.dataSource = self
        
        self.view.addSubview(self.tableView)
    }
    
    override func loadInfo() {
        
        SVProgressHUD.show()
        HRMSApi.POST(API_EVENT_INFO, params: ["PERNR": self.memberId!]) { (eventInfoResponse: EventInfoResponse?, error: HRMSError?) in
            SVProgressHUD.dismiss()
            
            guard eventInfoResponse != nil else {
                SVProgressHUD.showError(withStatus: error?.message)
                return
            }
            
            if eventInfoResponse?.success == -1 {
                SVProgressHUD.showError(withStatus: "失败.")
                return
            }
            
            let events = eventInfoResponse?.events //as [eventInfo]?
            let paramList = eventInfoResponse?.paramList //as eventParams?
            
            for event in events! {
                
                var paramMassn: String?
                for param in (paramList?.par002)! as [ParamModel]{
                    if param.value == event.massn {
                        paramMassn = param.name
                    }
                }
                
                var paramEstua: String?
                for param in (paramList?.par003)! as [ParamModel]{
                    if param.value == event.estua {
                        paramEstua = param.name
                    }
                }
                
                var paramMassg: String?
                var list = [ParamModel]()
                if event.massn == "01" {
                    list = (paramList?.par041)!
                } else if event.massn == "02" {
                    list = (paramList?.par042)!
                } else if event.massn == "03" {
                    list = (paramList?.par043)!
                } else if event.massn == "04" {
                    list = (paramList?.par044)!
                } else if event.massn == "05" {
                    list = (paramList?.par045)!
                } else if event.massn == "08" {
                    list = (paramList?.par046)!
                }
                if event.massn == "06" {
                    paramMassg = "退休"
                } else if event.massn == "07" {
                    paramMassg = "返聘"
                } else {
                    for param in list {
                        if param.value == event.estua {
                            paramMassg = param.name
                        }
                    }
                }
                
                let items = [
                    SectionItem(key: "事件类型", keyTitle: "事 件 类 型:", value: throwEmpty(paramMassn)!),
                    SectionItem(key: "事件日期", keyTitle: "事 件 日 期:", value: throwEmpty(event.begda)!),
                    SectionItem(key: "事件原因", keyTitle: "事 件 原 因:", value: throwEmpty(paramMassg)!),
                    SectionItem(key: "员工状态", keyTitle: "员 工 状 态:", value: throwEmpty(paramEstua)!)
                ]
                self.sections.append(SectionInfo(name: throwEmpty(paramMassn)!, items: items))
                
            }

            self.tableView.reloadData()
        }
    }
}
