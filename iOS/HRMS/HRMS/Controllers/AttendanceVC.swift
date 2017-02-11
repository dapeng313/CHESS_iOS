//
//  AttendanceVC.swift
//  HRMS
//
//  Created by Apollo on 1/20/17.
//  Copyright © 2017 Apollo. All rights reserved.
//

import UIKit
import SVProgressHUD
import Stevia
import AvatarImageView
import Alamofire

class AttendanceVC: UIViewController, MAMapViewDelegate {

    @IBOutlet weak var mapView: MAMapView!
    @IBOutlet weak var orderView: UILabel!
    @IBOutlet weak var timeView: UILabel!
    @IBOutlet weak var dateView: UILabel!
    @IBOutlet weak var contentsView: UIStackView!

    @IBOutlet weak var inLabel: UILabel!
    @IBOutlet weak var inLabelAlert: UILabel!
    @IBOutlet weak var btnInRequest: UIButton!

    @IBOutlet weak var outLabel: UILabel!
    @IBOutlet weak var outLabelAlert: UILabel!
    @IBOutlet weak var btnOutRequest: UIButton!

    @IBOutlet weak var finishedLabel: UILabel!
    
    @IBOutlet weak var btnInOut: UIButton!

    var outView = UIView()
    var finishedView = UIView()

    var dateString = ""
    var timeString = ""
    var pernr: String?
    var shiftInfo: ShiftInfo?
    let timeFormat = DateFormatter()
    let dateFormat = DateFormatter()
    let dateFormat4Compare = DateFormatter()
    let dateFormatShiftInfo = DateFormatter()

    override func viewDidLoad() {
        super.viewDidLoad()

        initVariables()

        setupUI()

        getShiftInfo()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        self.navigationController!.setNavigationBarHidden(false, animated: true)
        self.navigationItem.backBarButtonItem = UIBarButtonItem(title: "", style: .plain, target: nil, action: nil)
        
        self.navigationItem.title = NSLocalizedString("attendance", comment: "")
        self.navigationController?.navigationBar.frame = CGRect(x: 0, y: 0, width: (self.view.frame.width), height: 75)
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func initVariables() {
        
        if self.pernr == nil || self.pernr?.isEmpty == true {
            self.pernr = User.getUserId()
        }
        
        let timer = Timer.scheduledTimer(timeInterval: 0.5, target: self, selector: #selector(self.onTimer), userInfo: nil, repeats: true)

        let date = Date()

        dateFormat.dateFormat = "yyyy-MM-dd"
        dateString = dateFormat.string(from: date)

        timeFormat.dateFormat = "HH:mm"
        dateFormat4Compare.dateFormat = "yyyy-MM-dd-HH:mm"
        dateFormatShiftInfo.dateFormat = "yyyy-MM-dd-HH:mm:ss"

    }
    
    func setupUI() {
        
        dateView.text = dateString
        orderView.text = "您需要在公司规定的时间，电脑，手机签到"
        
        inLabel.text = "签到"
        inLabelAlert.text = "迟到"
        inLabelAlert.isHidden = true
        btnInRequest.setTitle("申诉", for: .normal)
        btnInRequest.tap(self.onRequest)
        
        outLabel.text = "签退"
        outLabelAlert.text = "早退"
        outLabelAlert.isHidden = true
        btnOutRequest.setTitle("申诉", for: .normal)
        btnOutRequest.tap(self.onRequest)
        
        outView = contentsView.arrangedSubviews[1]
        outView.isHidden = true
        
        finishedLabel.text = "工作已经结速了，做您想做的事请吧！"
        
        finishedView = contentsView.arrangedSubviews[2]
        finishedView.isHidden = true
        
        btnInOut.setTitle("签到", for: .normal)
        btnInOut.backgroundColor = UIColor.blue
        btnInOut.tap(self.onInOut)
        
        initMapView()
        
    }

    func initMapView() {
        mapView.delegate = self
        mapView.showsUserLocation = true
        mapView.zoomLevel = 15

        let locManager = CLLocationManager()
        locManager.requestWhenInUseAuthorization()
        
        if( CLLocationManager.authorizationStatus() == CLAuthorizationStatus.authorizedWhenInUse ||
            CLLocationManager.authorizationStatus() == CLAuthorizationStatus.authorizedAlways) {
            self.mapView.setCenter(locManager.location!.coordinate, animated: true)
        }
    }

    func getShiftInfo() {

        SVProgressHUD.show()
        HRMSApi.POST(API_GET_SHIFT_INFO, params: ["MEMBERID": self.pernr!]) { (shiftInfoResponse: ShiftInfoResponse?, error: HRMSError?) in
            SVProgressHUD.dismiss()
            
            guard shiftInfoResponse != nil else {
                SVProgressHUD.showError(withStatus: error?.message)
                return
            }
            
            if shiftInfoResponse?.success == -1 {
                SVProgressHUD.showError(withStatus: "失败.")
                return
            }

            self.shiftInfo = shiftInfoResponse?.data
            self.updateUI()
        }
    }
 
    func updateUI() {
        timeView.text = "默认班次: "+shiftInfo!.timin.substring(to: 5)+" - "+shiftInfo!.timou.substring(to: 5)
        
        let userStatus = UserDefaults.standard.integer(forKey: self.dateString+"_signin_status_"+pernr!)

        //TimeIn View
        if userStatus == 0 {
            inLabelAlert.isHidden = true
        } else {
            let cloin = UserDefaults.standard.string(forKey: self.dateString+"_timein_"+pernr!) as String?
            let timeIn = dateFormat4Compare.date(from: dateString+"-"+cloin!)
            let timeShiftInfo = dateFormatShiftInfo.date(from: dateString+"-"+(shiftInfo?.timin)!)
            inLabelAlert.isHidden = timeIn?.compare(timeShiftInfo!) == ComparisonResult.orderedAscending

            if UserDefaults.standard.bool(forKey: self.dateString+"_appeal_in") {
                btnInRequest.setTitle("已申诉", for: .normal)
            }
        }
        
        //TimeOut View
        if userStatus < 2 {
            outView.isHidden = true
            finishedView.isHidden = true
        } else {
            outView.isHidden = false
            finishedView.isHidden = false

            let cloout = UserDefaults.standard.string(forKey: self.dateString+"_timeout_"+pernr!) as String?
            let timeOut = dateFormat4Compare.date(from: dateString+"-"+cloout!)
            let timeShiftInfo = dateFormatShiftInfo.date(from: dateString+"-"+(shiftInfo?.timou)!)
            outLabelAlert.isHidden = timeOut?.compare(timeShiftInfo!) == ComparisonResult.orderedDescending
            
            if UserDefaults.standard.bool(forKey: self.dateString+"_appeal_out") {
                btnOutRequest.setTitle("已申诉", for: .normal)
            }
        }
    }

    func onInOut() {

        var cloin = UserDefaults.standard.string(forKey: self.dateString+"_timein_"+pernr!) as String?
        if cloin == nil {
            cloin = "00:00"
        }
        
        let userStatus = UserDefaults.standard.integer(forKey: self.dateString+"_signin_status_"+pernr!)

        let params : Parameters?

        if userStatus > 1 {
            let cloou = UserDefaults.standard.string(forKey: self.dateString+"_timeout_"+pernr!) as String?
            if cloin == nil {
                cloin = "00:00"
            }
            params = ["ROW_ID": 0, "PERNR": self.pernr!, "CLODA": dateString, "CLOIN": cloin!, "CINAD": cloin!, "CLORM": "", "CLOOU": cloou!, "COUAD": cloou!]
        } else {
            params = ["ROW_ID": 0, "PERNR": self.pernr!, "CLODA": dateString, "CLOIN": cloin!, "CINAD": cloin!, "CLORM": ""]
        }

        SVProgressHUD.show()
        HRMSApi.POST(API_SAVE_PUNCH_INFO, params: params) { (response: HRMSResponse?, error: HRMSError?) in
            SVProgressHUD.dismiss()
            
            guard response != nil else {
                SVProgressHUD.showError(withStatus: error?.message)
                return
            }
            
            if response?.success == -1 {
                SVProgressHUD.showError(withStatus: "失败.")
                return
            }
            if userStatus == 0 {
                UserDefaults.standard.set(1, forKey: self.dateString+"_signin_status_"+self.pernr!)
                UserDefaults.standard.set(self.timeString, forKey: self.dateString+"_timein_"+self.pernr!)
            } else if userStatus == 1 {
                UserDefaults.standard.set(2, forKey: self.dateString+"_signin_status_"+self.pernr!)
                UserDefaults.standard.set(self.timeString, forKey: self.dateString+"_timeout_"+self.pernr!)
            }

            self.updateUI()
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

    func onTimer() {
        let date = Date()

        timeString = timeFormat.string(from: date)
        
        let userStatus = UserDefaults.standard.integer(forKey: self.dateString+"_signin_status_"+pernr!)
        
        //TimeIn View
        if userStatus == 0 {
            btnInOut.setTitle("签到 "+timeString, for: .normal)
            btnInOut.isHidden = false
        } else if userStatus == 1{
            btnInOut.setTitle("签退 "+timeString, for: .normal)
            btnInOut.isHidden = false
        } else {
            btnInOut.isHidden = true
        }
    }

}
