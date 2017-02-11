//
//  LogVC.swift
//  HRMS
//
//  Created by Apollo on 1/31/17.
//  Copyright © 2017 Apollo. All rights reserved.
//

import UIKit

import UIKit
import FSCalendar
import SVProgressHUD

class LogVC: UIViewController, FSCalendarDataSource, FSCalendarDelegate, FSCalendarDelegateAppearance {
    
    @IBOutlet weak var calendarView: FSCalendar!
    @IBOutlet weak var contentsView: UIView!
    @IBOutlet weak var dateLabel: UILabel!
    @IBOutlet weak var contentsLabel: UILabel!
    @IBOutlet weak var btnRequest: UIButton!
    @IBOutlet weak var btnDetail: UIButton!
    
    var memberId: String?
    var logList: [LogInfo]?
    var selectedDate = Date()
    fileprivate lazy var dateFormat: DateFormatter = {
        let formatter = DateFormatter()
        formatter.dateFormat = "yyyy-MM-dd"
        return formatter
    }()

    fileprivate lazy var dateFormat2Send: DateFormatter = {
        let formatter = DateFormatter()
        formatter.dateFormat = "yyyy-MM"
        return formatter
    }()
    
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
            self.navigationItem.title = "我的日志"//NSLocalizedString("setting", comment: "")
        } else {
            self.navigationItem.title = "下属日志"//NSLocalizedString("setting", comment: "")
        }
        
        self.navigationController?.navigationBar.frame = CGRect(x: 0, y: 0, width: (self.view.frame.width), height: 75)

        loadData(Date())
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
        
        contentsView.layer.borderColor = UIColor.groupTableViewBackground.cgColor
        
        btnRequest.tap(onRequest)
        btnRequest.isHidden = true
        btnDetail.tap(onLogDetail)
    }
    
    func loadData(_ date: Date) {

        logList?.removeAll()
        
        SVProgressHUD.show()
        HRMSApi.POST(API_LOG_LIST_INFO, params: ["APPLY_ID": self.memberId!, "WORK_DATE": dateFormat2Send.string(from: date)]) { (infoResponse: LogInfoResponse?, error: HRMSError?) in
            SVProgressHUD.dismiss()
            
            guard infoResponse != nil else {
                SVProgressHUD.showError(withStatus: error?.message)
                return
            }
            
            if infoResponse?.success == -1 {
                SVProgressHUD.showError(withStatus: "失败.")
                return
            }
            
            self.logList = infoResponse?.data
            
            self.calendarView.reloadData()
        }
    }
    
    func onRequest() {

    }
    
    func onLogDetail() {
        let vc = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "LogDetailVC")
        self.navigationController?.pushViewController(vc, animated: true)
    }
    
    func getInfoFor(_ date: Date) -> LogInfo? {
        if self.logList == nil {
            return nil
        }
        
        for info in self.logList! {
            if info.workDate == dateFormat.string(from: date) {
                return info
            }
        }
        return nil
    }
    
    //FSCalendar - action
    func calendar(_ calendar: FSCalendar, didSelect date: Date) {
        
        let info = getInfoFor(date)

        if info == nil {
            btnRequest.isHidden = true
            btnDetail.isHidden = false
        } else {
           
            let year = self.calendar.component(.year, from: date)
            let month = self.calendar.component(.month, from: date)
            let date = self.calendar.component(.day, from: date)
            
            dateLabel.text = " "+String(year)+"年"+String(month)+"月"+String(date)+"日"

            if info?.workContent != nil && info?.workContent.isEmpty == false {
                contentsLabel.text = info?.workContent
            } else {
                contentsLabel.text = ""
            }

            if info?.releaseFlag == "01" {
                btnRequest.isHidden = false
                btnRequest.backgroundColor = UIColor.magenta
                btnRequest.setTitle("发布", for: .normal)
                btnDetail.isHidden = true
            } else if info?.releaseFlag == "02" {
                btnRequest.isHidden = false
                btnRequest.backgroundColor = Colors.primary
                btnRequest.setTitle("已发布", for: .normal)
                btnDetail.isHidden = true
            } else {
                btnRequest.isHidden = true
                btnDetail.isHidden = false
            }

            
            if self.memberId == User.getUserId() {
                btnRequest.isHidden = false
                btnDetail.isHidden = false
            } else {
                btnRequest.isHidden = true
                btnDetail.isHidden = false
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
    
    func calendar(_ calendar: FSCalendar, imageFor date: Date) -> UIImage? {
        let info = getInfoFor(date)

        if info == nil {
            return nil
        } else if info?.releaseFlag == "01" {
            return UIImage(named: "editing")
        } else if info?.releaseFlag == "02" {
            return UIImage(named: "done")
        } else {
            return nil
        }
    }

}
