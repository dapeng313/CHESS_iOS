//
//  SubAttendanceVC.swift
//  HRMS
//
//  Created by Apollo on 2/1/17.
//  Copyright © 2017 Apollo. All rights reserved.
//



import UIKit
import Charts
import SVProgressHUD
import AlamofireImage

class SubAttendanceVC: BaseBarChartVC {

    var titles: [String] = ["请假时数", "异常时数", "加班时数", "出差时数"]
    var counts: [Double] = [0, 0, 0, 0]
    
    override func viewDidLoad() {
        super.viewDidLoad()

        barColors = [UIColor.blue, UIColor.red, UIColor.green, UIColor.gray]
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        self.navigationItem.title = "下属考勤"//NSLocalizedString("setting", comment: "")

    }
    
    override func loadData() {
        
        SVProgressHUD.show()
        HRMSApi.POST(API_ATTENDANCE_CHART, params: ["memberID": User.getUserId()!]) { (subAttendanceInfoResponse: SubAttendanceInfoResponse?, error: HRMSError?) in
            SVProgressHUD.dismiss()
            
            guard subAttendanceInfoResponse != nil else {
                SVProgressHUD.showError(withStatus: error?.message)
                return
            }
            
            if subAttendanceInfoResponse?.success == -1 {
                SVProgressHUD.showError(withStatus: "失败.")
                return
            }
            
            for info in (subAttendanceInfoResponse?.pt1001List)! {
                self.counts[0] += 1
            }
            for info in (subAttendanceInfoResponse?.pt1004List)! {
                self.counts[1] += 1
            }
            for info in (subAttendanceInfoResponse?.pt1003List)! {
                self.counts[2] += 1
            }
            for info in (subAttendanceInfoResponse?.pt1002List)! {
                self.counts[3] += 1
            }
            
            self.setChart(self.titles, values: self.counts)
        }
    }

    // MARK:  UITableViewDelegate Methods
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let vc = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "AttendanceInfoVC") as! AttendanceInfoVC
        vc.memberId = self.members[indexPath.row].id
        self.navigationController?.pushViewController(vc, animated: true)
    }
}
