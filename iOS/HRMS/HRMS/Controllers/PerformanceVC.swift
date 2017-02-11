//
//  PerformanceVC.swift
//  HRMS
//
//  Created by Apollo on 1/30/17.
//  Copyright © 2017 Apollo. All rights reserved.
//

import UIKit
import SVProgressHUD

class PerformanceVC: BaseResumeInfoVC {

    @IBOutlet weak var startDateLabel: UILabel!
    @IBOutlet weak var endDateLabel: UILabel!
    @IBOutlet weak var mainView: UIView!
    
    var year: Int = 2017

    override func viewDidLoad() {
        super.viewDidLoad()

        year = Calendar.current.component(.year, from: Date())

        startDateLabel.text = String(year)+"年 1月"
        endDateLabel.text = String(year)+"年 12月"

        tableView.frame = CGRect(x: 0, y: 20, width: APP_WIDTH, height: self.mainView.frame.height - 40)
        tableView.delegate = self
        tableView.dataSource = self

        self.mainView.addSubview(self.tableView)
    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        self.navigationController!.setNavigationBarHidden(false, animated: true)
        self.navigationItem.backBarButtonItem = UIBarButtonItem(title: "", style: .plain, target: nil, action: nil)

        if self.memberId == nil || self.memberId?.isEmpty == true || self.memberId == User.getUserId() {
            self.navigationItem.title = "我的考核"//NSLocalizedString("setting", comment: "")
        } else {
            self.navigationItem.title = "下属考核"//NSLocalizedString("setting", comment: "")
        }
        
        self.navigationController?.navigationBar.frame = CGRect(x: 0, y: 0, width: (self.view.frame.width), height: 75)
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    override func loadInfo() {
        
        SVProgressHUD.show()
        HRMSApi.POST(API_PERFORMANCE_INFO, params: ["PERNR": self.memberId!, "BEGDA": String(year)+"-01-01", "ENDDA": String(year)+"-12-31"]) { (performanceInfoResponse: PerformanceInfoResponse?, error: HRMSError?) in
            SVProgressHUD.dismiss()
            
            guard performanceInfoResponse != nil else {
                SVProgressHUD.showError(withStatus: error?.message)
                return
            }
            
            if performanceInfoResponse?.success == -1 {
                SVProgressHUD.showError(withStatus: "失败.")
                return
            }
            
            let performances = performanceInfoResponse?.data //as [PerformanceInfo]?
            
            for performance in performances! {
                var strPefType = ""
                if performance.pefty == "01" {
                    strPefType = "年度"
                } else if performance.pefty == "02" {
                    strPefType = "半年度"
                } else if performance.pefty == "03" {
                    strPefType = "季度"
                } else if performance.pefty == "04" {
                    strPefType = "月度"
                } else if performance.pefty == "05" {
                    strPefType = "其他"
                }
                let items = [
                    SectionItem(key: "考核类型", keyTitle: "考核类型:", value: throwEmpty(strPefType)!),
                    SectionItem(key: "开始日期", keyTitle: "开始日期:", value: throwEmpty(performance.begda)!),
                    SectionItem(key: "结束日期", keyTitle: "结束日期:", value: throwEmpty(performance.endda)!),
                    SectionItem(key: "考核年度", keyTitle: "考核年度:", value: throwEmpty(performance.pefya)!),
                    SectionItem(key: "考核等级", keyTitle: "考核等级:", value: throwEmpty(performance.peflv)!),
                    SectionItem(key: "考核分数", keyTitle: "考核分数:", value: String(performance.pefsc))
                ]
                self.sections.append(SectionInfo(name: throwEmpty(performance.begda)!+" ~ "+throwEmpty(performance.endda)!, items: items))
                
            }
            
            self.tableView.reloadData()
        }
    }
}
