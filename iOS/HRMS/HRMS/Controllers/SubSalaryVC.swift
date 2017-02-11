//
//  SubSalaryVC.swift
//  HRMS
//
//  Created by Apollo on 1/31/17.
//  Copyright © 2017 Apollo. All rights reserved.
//

import UIKit
import Charts
import SVProgressHUD
import AlamofireImage


class SubSalaryVC: BaseBarChartVC {

    var months: [String]?
    var monthTotal = [Double]()

    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        self.navigationItem.title = "下属薪酬"//NSLocalizedString("setting", comment: "")
    }

    override func loadData() {
        
        SVProgressHUD.show()
        HRMSApi.POST(API_SALARY_CHART, params: ["memberID": User.getUserId()!]) { (subSalaryInfoResponse: SubSalaryInfoResponse?, error: HRMSError?) in
            SVProgressHUD.dismiss()
            
            guard subSalaryInfoResponse != nil else {
                SVProgressHUD.showError(withStatus: error?.message)
                return
            }
            
            if subSalaryInfoResponse?.success == -1 {
                SVProgressHUD.showError(withStatus: "失败.")
                return
            }

            self.months = subSalaryInfoResponse?.monthList

            for _ in (subSalaryInfoResponse?.monthList)! {
                self.monthTotal.append(0)
            }

            for salaryInfo in (subSalaryInfoResponse?.data)! {
                for monthInfo in (subSalaryInfoResponse?.monthList)! {
                    if salaryInfo.paydate == monthInfo {
                        let index = subSalaryInfoResponse?.monthList?.index(of: monthInfo)
                        self.monthTotal[index!] += salaryInfo.p101
                    }
                }
            }

            self.setChart(self.months!, values: self.monthTotal)
        }
    }
    
    // MARK:  UITableViewDelegate Methods
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let vc = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "SalaryVC") as! SalaryVC
        vc.memberId = self.members[indexPath.row].id
        self.navigationController?.pushViewController(vc, animated: true)
    }
}
