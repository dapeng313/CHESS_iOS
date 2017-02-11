//
//  SubPerformanceVC.swift
//  HRMS
//
//  Created by Apollo on 2/1/17.
//  Copyright © 2017 Apollo. All rights reserved.
//


import UIKit
import Charts
import SVProgressHUD
import AlamofireImage


class SubPerformanceVC: BaseBarChartVC {

    var titles: [String] = [">100", "91~100", "81~90", "71~80", "61~70", "0~60"]
    var counts: [Double] = [0, 0, 0, 0, 0, 0]

    override func viewDidLoad() {
        super.viewDidLoad()

        barColors = [UIColor.blue, UIColor.red, UIColor.green, UIColor.cyan, UIColor.gray, UIColor.yellow]
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        self.navigationItem.title = "下属薪酬"//NSLocalizedString("setting", comment: "")
    }

    override func loadData() {
        
        SVProgressHUD.show()
        HRMSApi.POST(API_ASSESS_CHART, params: ["memberID": User.getUserId()!]) { (subPerformanceInfoResponse: SubPerformanceInfoResponse?, error: HRMSError?) in
            SVProgressHUD.dismiss()
            
            guard subPerformanceInfoResponse != nil else {
                SVProgressHUD.showError(withStatus: error?.message)
                return
            }
            
            if subPerformanceInfoResponse?.success == -1 {
                SVProgressHUD.showError(withStatus: "失败.")
                return
            }
            
            for info in (subPerformanceInfoResponse?.data)! {
                
                if info.pefsc > 100 {
                    self.counts[0] += 1
                } else if info.pefsc > 90 {
                    self.counts[1] += 1
                } else if info.pefsc > 80 {
                    self.counts[2] += 1
                } else if info.pefsc > 70 {
                    self.counts[3] += 1
                } else if info.pefsc > 60 {
                    self.counts[4] += 1
                } else {
                    self.counts[5] += 1
                }
            }
            
            self.setChart(self.titles, values: self.counts)
        }
    }
   
    // MARK:  UITableViewDelegate Methods
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let vc = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "PerformanceVC") as! PerformanceVC
        vc.memberId = self.members[indexPath.row].id
        self.navigationController?.pushViewController(vc, animated: true)
    }
}
