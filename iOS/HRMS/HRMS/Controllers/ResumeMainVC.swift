//
//  ResumeMainVC.swift
//  HRMS
//
//  Created by Apollo on 1/23/17.
//  Copyright © 2017 Apollo. All rights reserved.
//

import UIKit
import SVProgressHUD

class ResumeMainVC: BaseResumeInfoVC {


    override func viewDidLoad() {
        super.viewDidLoad()

        tableView.delegate = self
        tableView.dataSource = self

        self.view.addSubview(self.tableView)
    }

    override func loadInfo() {

        SVProgressHUD.show()
        HRMSApi.POST(API_PERSON_BASE, params: ["PERNR": self.memberId!]) { (baseInfoResponse: BaseInfoResponse?, error: HRMSError?) in
            SVProgressHUD.dismiss()
            
            guard baseInfoResponse != nil else {
                SVProgressHUD.showError(withStatus: error?.message)
                return
            }
            
            if baseInfoResponse?.success == -1 {
                SVProgressHUD.showError(withStatus: "失败.")
                return
            }

            //pa1001 - info
            let pa1001 = baseInfoResponse?.pa1001 as PA1001?
            let paramList = baseInfoResponse?.paramList as BaseParams?

            var paramPersg: String?
            for param in (paramList?.par037)! as [ParamModel]{
                if param.value == pa1001?.persg {
                    paramPersg = param.name
                }
            }

            var paramPersk: String?
            var list = [ParamModel]()
            if pa1001?.persg == "01" {
                list = (paramList?.par038)!
            } else if pa1001?.persg == "02" {
                list = (paramList?.par039)!
            } else if pa1001?.persg == "03" {
                list = (paramList?.par040)!
            }
            for param in list {
                if param.value == pa1001?.persk {
                    paramPersk = param.name
                }
            }

            let items1 = [
                SectionItem(key: "公司代码", keyTitle: "公司代码:", value: throwEmpty(baseInfoResponse?.coname)!),
                SectionItem(key: "成本中心", keyTitle: "成本中心:", value: throwEmpty(pa1001?.kostl)!),
                SectionItem(key: "人事范围", keyTitle: "人事范围:", value: throwEmpty(pa1001?.werks)!),
                SectionItem(key: "人事子范围", keyTitle: "人事子范围:", value: throwEmpty(pa1001?.btrtl)!),
                SectionItem(key: "员工组", keyTitle: "员工组:", value: throwEmpty(paramPersg)!),
                SectionItem(key: "员工子组", keyTitle: "员工子组:", value: throwEmpty(paramPersk)!)
            ]

            //pa1002 - info
            let pa1002 = baseInfoResponse?.pa1002 as PA1002?
            
            var paramGesch: String?
            for param in (paramList?.par004)! as [ParamModel]{
                if param.value == pa1002?.gesch {
                    paramGesch = param.name
                }
            }
            
            var paramCountry: String?
            for param in (baseInfoResponse?.countryList)! as [ParamModel]{
                if param.value == pa1002?.natio {
                    paramCountry = param.name
                }
            }
            
            var paramNational: String?
            for param in (baseInfoResponse?.nationalList)! as [ParamModel]{
                if param.value == pa1002?.racky {
                    paramNational = param.name
                }
            }
            
            var paramPcode: String?
            for param in (paramList?.par005)! as [ParamModel]{
                if param.value == pa1002?.gesch {
                    paramPcode = param.name
                }
            }
            
            var paramFatxt: String?
            for param in (paramList?.par006)! as [ParamModel]{
                if param.value == pa1002?.gesch {
                    paramFatxt = param.name
                }
            }

            let items2 = [
                SectionItem(key: "人职日期", keyTitle: "人职日期:", value: throwEmpty(pa1002?.endat)!),
                SectionItem(key: "参加工作日期", keyTitle: "参加工作日期:", value: throwEmpty(pa1002?.jwdat)!),
                SectionItem(key: "性别", keyTitle: "性 别:", value: throwEmpty(paramGesch)!),
                SectionItem(key: "英文名称", keyTitle: "英文名称:", value: throwEmpty(pa1002?.vorna)!),
                SectionItem(key: "身份证号码", keyTitle: "身份证号码:", value: throwEmpty(pa1002?.perid)!),
                SectionItem(key: "出生日期", keyTitle: "出生日期:", value: throwEmpty(pa1002?.gbdat)!),
                SectionItem(key: "国籍", keyTitle: "国 籍:", value: throwEmpty(paramCountry)!),
                SectionItem(key: "民族", keyTitle: "民 族:", value: throwEmpty(paramNational)!),
                SectionItem(key: "籍贯", keyTitle: "籍 贯:", value: throwEmpty(pa1002?.gbdep)!),
                SectionItem(key: "出生地", keyTitle: "出生地:", value: throwEmpty(pa1002?.gbort)!),
                SectionItem(key: "婚姻状况", keyTitle: "婚姻状况:", value: throwEmpty(paramFatxt)!),
                SectionItem(key: "政治面貌", keyTitle: "政治面貌:", value: throwEmpty(paramPcode)!)
            ]

            self.sections = [
                SectionInfo(name: "组织信息", items: items1),
                SectionInfo(name: "个人信息", items: items2)
            ]
            
            self.tableView.reloadData()
        }
    }
}
