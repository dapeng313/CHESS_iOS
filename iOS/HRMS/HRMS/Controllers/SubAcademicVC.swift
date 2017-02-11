//
//  SubResumeVC.swift
//  HRMS
//
//  Created by Apollo on 2/1/17.
//  Copyright © 2017 Apollo. All rights reserved.
//
//
//  SubAcademicVC.swift
//  HRMS
//
//  Created by Apollo on 2/1/17.
//  Copyright © 2017 Apollo. All rights reserved.
//


import UIKit
import Charts
import SVProgressHUD
import AlamofireImage


class SubAcademicVC: BaseBarChartVC {
    
   
    var titles: [String] = ["大专", "本科", "硕士及以上", "高中及以下"]
    var counts: [Double] = [0, 0, 0, 0]
    
    override func viewDidLoad() {
        super.viewDidLoad()

        barColors = ChartColorTemplates.material()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        self.navigationItem.title = "下属信息"//NSLocalizedString("setting", comment: "")
    }
    
    override func loadData() {
        
        SVProgressHUD.show()
        HRMSApi.POST(API_ACADEMIC_CHART, params: ["memberID": User.getUserId()!]) { (subAcademicInfoResponse: SubAcademicInfoResponse?, error: HRMSError?) in
            SVProgressHUD.dismiss()
            
            guard subAcademicInfoResponse != nil else {
                SVProgressHUD.showError(withStatus: error?.message)
                return
            }
            
            if subAcademicInfoResponse?.success == -1 {
                SVProgressHUD.showError(withStatus: "失败.")
                return
            }
            
            for info in (subAcademicInfoResponse?.universityList)! {
                self.counts[0] += 1
            }
            for info in (subAcademicInfoResponse?.collegeList)! {
                self.counts[1] += 1
            }
            for info in (subAcademicInfoResponse?.masterList)! {
                self.counts[2] += 1
            }
            for info in (subAcademicInfoResponse?.highSchoolList)! {
                self.counts[3] += 1
            }

            self.setChart(self.titles, values: self.counts)
        }
    }

    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let vc = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "ResumeVC") as! ResumeVC
        vc.memberId = self.members[indexPath.row].id
        vc.user = self.members[indexPath.row]
        self.navigationController?.pushViewController(vc, animated: true)
    }
}
