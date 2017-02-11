//
//  AttendanceInfoVC.swift
//  HRMS
//
//  Created by Apollo on 1/27/17.
//  Copyright © 2017 Apollo. All rights reserved.
//

import UIKit
import FSCalendar
import SVProgressHUD

class AttendanceInfoVC: UIViewController, FSCalendarDataSource, FSCalendarDelegate, FSCalendarDelegateAppearance {
    
    @IBOutlet weak var calendarView: FSCalendar!
    @IBOutlet weak var contentsView: UIStackView!
    @IBOutlet weak var dateLabel: UILabel!
    @IBOutlet weak var statusLabel: UILabel!
    @IBOutlet weak var reasonLabel: UILabel!
    @IBOutlet weak var appealLabel: UILabel!
    @IBOutlet weak var countLabel1: UILabel!
    @IBOutlet weak var countLabel4: UILabel!
    @IBOutlet weak var countLabel3: UILabel!
    @IBOutlet weak var countLabel2: UILabel!
    @IBOutlet weak var btnAppeal: UIButton!
    @IBOutlet weak var statusView: UIView!
    @IBOutlet weak var statisticsView: UIView!
    
    var memberId: String?
    var infoList: [AttendanceInfo]?
    var selectedDate = Date()
    fileprivate lazy var dateFormat: DateFormatter = {
        let formatter = DateFormatter()
        formatter.dateFormat = "yyyy-MM-dd"
        return formatter
    }()
    
    let statusColors = [UIColor.red, UIColor.blue, UIColor.blue, UIColor.green, UIColor.yellow, UIColor.yellow, UIColor.blue]

    let calendar = Calendar.current

    override func viewDidLoad() {
        super.viewDidLoad()

        if self.memberId == nil || self.memberId?.isEmpty == true {
            self.memberId = User.getUserId()
        }

        setupUI()

        loadData(Date())
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        self.navigationController!.setNavigationBarHidden(false, animated: true)
        self.navigationItem.backBarButtonItem = UIBarButtonItem(title: "", style: .plain, target: nil, action: nil)
        
        if self.memberId == nil || self.memberId?.isEmpty == true || self.memberId == User.getUserId(){
            self.navigationItem.title = "我的考勤"//NSLocalizedString("setting", comment: "")
        } else {
            self.navigationItem.title = "下属考勤"//NSLocalizedString("setting", comment: "")
        }

        self.navigationController?.navigationBar.frame = CGRect(x: 0, y: 0, width: (self.view.frame.width), height: 75)
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func setupUI() {
        calendarView.swipeToChooseGesture.isEnabled = true
        calendarView.backgroundColor = UIColor.white
        calendarView.appearance.caseOptions = [.headerUsesUpperCase,.weekdayUsesSingleUpperCase]
        calendarView.select(Date())

        statusView.layer.borderColor = UIColor.groupTableViewBackground.cgColor
        statisticsView.layer.borderColor = UIColor.groupTableViewBackground.cgColor

        btnAppeal.tap(onRequest)
    }
    
    func loadData(_ date: Date) {
        
        let year = calendar.component(.year, from: date)
        let month = calendar.component(.month, from: date)
        
        loadData(year, month)
    }
   
    func loadData(_ year: Int, _ month: Int) {
        infoList?.removeAll()
 
        SVProgressHUD.show()
        HRMSApi.POST(API_PUNCH_INFO_FOR_MONTH, params: ["PERNR": self.memberId!, "year": year, "month": month]) { (infoResponse: AttendanceInfoResponse?, error: HRMSError?) in
            SVProgressHUD.dismiss()
            
            guard infoResponse != nil else {
                SVProgressHUD.showError(withStatus: error?.message)
                return
            }
            
            if infoResponse?.success == -1 {
                SVProgressHUD.showError(withStatus: "失败.")
                return
            }

            self.infoList = infoResponse?.data
            
            self.calendarView.reloadData()

            var count1 = 0
            var count2 = 0
            var count3 = 0
            var count4 = 0

            for info in self.infoList! {
                if info.intype == AttendanceInfo.LEAVE_EARLY || info.intype == AttendanceInfo.LATE {
                    count1 += 1
                } else if info.intype == AttendanceInfo.ABSENCE {
                    count2 += 1
                } else if info.intype == AttendanceInfo.TRAVEL || info.intype == AttendanceInfo.OVERTIME {
                    count3 += 1
                } else if info.intype == AttendanceInfo.MISSING_CARD {
                    count4 += 1
                } else if info.intype == AttendanceInfo.NORMAL {
                    if info.intype == AttendanceInfo.LEAVE_EARLY || info.intype == AttendanceInfo.LATE {
                        count1 += 1
                    } else if info.intype == AttendanceInfo.ABSENCE {
                        count2 += 1
                    } else if info.intype == AttendanceInfo.TRAVEL || info.intype == AttendanceInfo.OVERTIME {
                        count3 += 1
                    } else if info.intype == AttendanceInfo.MISSING_CARD {
                        count4 += 1
                    }
                }
            }

            self.countLabel1.text = String(count1)+"次"
            self.countLabel2.text = String(count2)+"次"
            self.countLabel3.text = String(count3)+"次"
            self.countLabel4.text = String(count4)+"次"
        }
    }

    func onRequest() {
        let alert = UIAlertController(title: nil, message: nil, preferredStyle: .actionSheet)
        let firstAction = UIAlertAction(title: "日常申请", style: .default) { (alert: UIAlertAction!) -> Void in
            let vc = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "AppealDailyVC")
            self.navigationController?.pushViewController(vc, animated: true)
        }
        
        let secondAction = UIAlertAction(title: "请假申请", style: .default) { (alert: UIAlertAction!) -> Void in
            let vc = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "AppealAbsenceVC") as! AppealAbsenceVC
            vc.vcType = 0
            self.navigationController?.pushViewController(vc, animated: true)
        }

        let thirdAction = UIAlertAction(title: "出差申请", style: .default) { (alert: UIAlertAction!) -> Void in
            let vc = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "AppealTravelVC")
            self.navigationController?.pushViewController(vc, animated: true)
        }
        
        let fourthAction = UIAlertAction(title: "加班申请", style: .default) { (alert: UIAlertAction!) -> Void in
            let vc = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "AppealAbsenceVC") as! AppealAbsenceVC
            vc.vcType = 1
            self.navigationController?.pushViewController(vc, animated: true)
        }

        let fifthAction = UIAlertAction(title: "考勤修正申请", style: .default) { (alert: UIAlertAction!) -> Void in
            let vc = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "AppealPunchVC")
            self.navigationController?.pushViewController(vc, animated: true)
        }
        
        alert.addAction(firstAction)
        alert.addAction(secondAction)
        alert.addAction(thirdAction)
        alert.addAction(fourthAction)
        alert.addAction(fifthAction)
        present(alert, animated: true, completion:nil)
    }

    func getInfoFor(_ date: Date) -> AttendanceInfo? {
        if self.infoList == nil {
            return nil
        }

        for info in self.infoList! {
            if info.date == dateFormat.string(from: date) {
                return info
            }
        }
        return nil
    }

    //FSCalendar - action
    func calendar(_ calendar: FSCalendar, didSelect date: Date) {
        
        let info = getInfoFor(date)
        
        if info == nil || info?.intype == AttendanceInfo.NORMAL && info?.outype == AttendanceInfo.NORMAL {
            dateLabel.isHidden = true
            contentsView.arrangedSubviews[0].isHidden = true
            //contentsView.arrangedSubviews[1].isHidden = true
        } else {
            dateLabel.isHidden = false
            contentsView.arrangedSubviews[0].isHidden = false
            //contentsView.arrangedSubviews[1].isHidden = false

            let year = self.calendar.component(.year, from: date)
            let month = self.calendar.component(.month, from: date)
            let date = self.calendar.component(.day, from: date)

            dateLabel.text = " "+String(year)+"年"+String(month)+"月"+String(date)+"日详情"
            statusLabel.text = AttendanceInfo.TYPE[(info?.intype)! - 1]
            if info?.intype == AttendanceInfo.NORMAL {
                statusLabel.text = AttendanceInfo.TYPE[(info?.outype)! - 1]
            }
            reasonLabel.text = throwEmpty(info?.reason)

            if self.memberId == User.getUserId() {
                btnAppeal.isHidden = false
            } else {
                btnAppeal.isHidden = true
            }
        }

        //self.calendarView.reloadData()
    }

    func calendarCurrentMonthDidChange(_ calendar: FSCalendar) {
        loadData(localFromUTCDate(calendar.currentPage))
    }


    //FSCalendar - appearance
    func calendar(_ calendar: FSCalendar, numberOfEventsFor date: Date) -> Int {
        if self.selectedDate == date {
            return 1
        }
        return 0
    }
    
    func calendar(_ calendar: FSCalendar, appearance: FSCalendarAppearance, eventColorFor date: Date) -> UIColor? {

        if self.selectedDate == date {
            return UIColor.red
        }
        return nil
    }
    
    func calendar(_ calendar: FSCalendar, appearance: FSCalendarAppearance, eventDefaultColorsFor date: Date) -> [UIColor]? {
        if self.selectedDate == date {
            return [UIColor.red]
        }
        return nil
    }
    
    func calendar(_ calendar: FSCalendar, appearance: FSCalendarAppearance, fillSelectionColorFor date: Date) -> UIColor? {
        
        let info = getInfoFor(date)

        if info == nil {
            return nil
        }

        if info?.intype != 7  {
            return self.statusColors[(info?.intype)!]
        } else if info?.outype != 7  {
            return self.statusColors[(info?.outype)!]
        }
        return nil
    }
    
    func calendar(_ calendar: FSCalendar, appearance: FSCalendarAppearance, fillDefaultColorFor date: Date) -> UIColor? {
        let info = getInfoFor(date)
        
        if info == nil {
            return nil
        }

        if info?.intype != AttendanceInfo.NORMAL  {
            return self.statusColors[(info?.intype)! - 1]
        } else if info?.outype != AttendanceInfo.NORMAL {
            return self.statusColors[(info?.outype)! - 1]
        }
        return nil
    }
}
