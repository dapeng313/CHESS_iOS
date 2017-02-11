//
//  ResumeContractVC.swift
//  HRMS
//
//  Created by Apollo on 1/23/17.
//  Copyright © 2017 Apollo. All rights reserved.
//

import UIKit
import SVProgressHUD

class ResumeContractVC: BaseResumeInfoVC {


    override func viewDidLoad() {
        super.viewDidLoad()

        tableView.delegate = self
        tableView.dataSource = self

        self.view.addSubview(self.tableView)
    }

    override func loadInfo() {

        SVProgressHUD.show()
        HRMSApi.POST(API_CONTACT_INFO, params: ["PERNR": self.memberId!]) { (contractInfoResponse: ContractInfoResponse?, error: HRMSError?) in
            SVProgressHUD.dismiss()
            
            guard contractInfoResponse != nil else {
                SVProgressHUD.showError(withStatus: error?.message)
                return
            }
            
            if contractInfoResponse?.success == -1 {
                SVProgressHUD.showError(withStatus: "失败.")
                return
            }

            let contracts = contractInfoResponse?.contracts //as [ContractInfo]?
            let paramList = contractInfoResponse?.paramList //as ContractParams?

            for contract in contracts! {
                
                var paramCttyp: String?
                for param in (paramList?.par026)! as [ParamModel]{
                    if param.value == contract.cttyp {
                        paramCttyp = param.name
                    }
                }
                
                var paramCtsel: String?
                for param in (paramList?.par027)! as [ParamModel]{
                    if param.value == contract.ctsel {
                        paramCtsel = param.name
                    }
                }
                
                var paramPrbeh: String?
                for param in (paramList?.par049)! as [ParamModel]{
                    if param.value == contract.prbeh {
                        paramPrbeh = param.name
                    }
                }

                let items = [
                    SectionItem(key: "入职日期", keyTitle: "入 职 日 期:", value: throwEmpty(contract.begda)!),
                    SectionItem(key: "合同类型", keyTitle: "合 同 类 型:", value: throwEmpty(paramCttyp)!),
                    SectionItem(key: "试用期", keyTitle: "试 用 期:", value: throwEmpty(contract.prbzt)!),
                    SectionItem(key: "合同密级", keyTitle: "合 同 密 级:", value: throwEmpty(paramCtsel)!),
                    SectionItem(key: "合同编号", keyTitle: "合 同 编 号:", value: throwEmpty(contract.ctnum)!),
                    SectionItem(key: "合同签订日期", keyTitle: "合同签订日期:", value: throwEmpty(contract.sidat)!),
                    SectionItem(key: "合同结束日期", keyTitle: "合同结束日期:", value: throwEmpty(contract.ctedt)!)
                ]
                self.sections.append(SectionInfo(name: contract.begda, items: items))

            }

            
            self.tableView.reloadData()
        }
    }
}
