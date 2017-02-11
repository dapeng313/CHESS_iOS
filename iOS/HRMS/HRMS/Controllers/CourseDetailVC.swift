//
//  CourseDetailVC.swift
//  HRMS
//
//  Created by Apollo on 2/7/17.
//  Copyright © 2017 Apollo. All rights reserved.
//


import UIKit
import Alamofire
import SVProgressHUD

class CourseDetailVC: BaseInputVC {
    
    @IBOutlet weak var counoField: UITextField!
    @IBOutlet weak var counaField: UITextField!
    @IBOutlet weak var contentsField: UITextView!
    @IBOutlet weak var trypeField: UITextField!
    @IBOutlet weak var couteField: UITextField!
    @IBOutlet weak var statusField: UITextField!
    @IBOutlet weak var couadField: UITextField!
    @IBOutlet weak var begdaField: UITextField!
    @IBOutlet weak var enddaField: UITextField!
    
    @IBOutlet weak var btnSend: UIButton!
    @IBOutlet weak var btnCancel: UIButton!
    
    
    var memberId: String?

    var courseInfo: CourseInfo?
    
    fileprivate lazy var dateFormat: DateFormatter = {
        let formatter = DateFormatter()
        formatter.dateFormat = "yyyy-MM-dd"
        return formatter
    }()
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        if self.memberId == nil || self.memberId?.isEmpty == true {
            self.memberId = User.getUserId()
        }
        
        setupUI()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        self.navigationItem.title = "课程内容"//NSLocalizedString("setting", comment: "")
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        self.view.endEditing(true)
    }
    
    func setupUI() {
        self.counoField.layer.borderColor = UIColor.groupTableViewBackground.cgColor
        
        let counoLabel = UILabel(frame: CGRect(x: 10, y: 0, width: 100, height: counoField.frame.size.height))
        counoLabel.style(leftLabelStyle)
        counoLabel.text = "课程编号"
        let counoView = UIView(frame: CGRect(x: 0, y: 0, width: 150, height: counoField.frame.size.height))
        counoView.addSubview(counoLabel)
        self.counoField.leftView = counoView
        self.counoField.leftViewMode = .always
        
        self.counaField.layer.borderColor = UIColor.groupTableViewBackground.cgColor
        
        let counaLabel = UILabel(frame: CGRect(x: 10, y: 0, width: 100, height: counaField.frame.size.height))
        counaLabel.style(leftLabelStyle)
        counaLabel.text = "课程名称"
        let counaView = UIView(frame: CGRect(x: 0, y: 0, width: 150, height: counaField.frame.size.height))
        counaView.addSubview(counaLabel)
        self.counaField.leftView = counaView
        self.counaField.leftViewMode = .always
        
        self.contentsField.layer.borderColor = UIColor.groupTableViewBackground.cgColor
        contentsField.placeholder = "课程详情";
        contentsField.placeholderColor = UIColor.lightGray;
        
        self.trypeField.layer.borderColor = UIColor.groupTableViewBackground.cgColor
        
        let trypeLabel = UILabel(frame: CGRect(x: 10, y: 0, width: 100, height: trypeField.frame.size.height))
        trypeLabel.style(leftLabelStyle)
        trypeLabel.text = "课程类型"
        let trypeLView = UIView(frame: CGRect(x: 0, y: 0, width: 150, height: trypeField.frame.size.height))
        trypeLView.addSubview(trypeLabel)
        self.trypeField.leftView = trypeLView
        self.trypeField.leftViewMode = .always
        
        self.couteField.layer.borderColor = UIColor.groupTableViewBackground.cgColor
        
        let couteLabel = UILabel(frame: CGRect(x: 10, y: 0, width: 100, height: couteField.frame.size.height))
        couteLabel.style(leftLabelStyle)
        couteLabel.text = "课程讲师"
        let couteLView = UIView(frame: CGRect(x: 0, y: 0, width: 150, height: couteField.frame.size.height))
        couteLView.addSubview(couteLabel)
        self.couteField.leftView = couteLView
        self.couteField.leftViewMode = .always
        
        self.statusField.layer.borderColor = UIColor.groupTableViewBackground.cgColor
        
        let statusLabel = UILabel(frame: CGRect(x: 10, y: 0, width: 100, height: statusField.frame.size.height))
        statusLabel.style(leftLabelStyle)
        statusLabel.text = "课程状态"
        let statusView = UIView(frame: CGRect(x: 0, y: 0, width: 150, height: statusField.frame.size.height))
        statusView.addSubview(statusLabel)
        self.statusField.leftView = statusView
        self.statusField.leftViewMode = .always
        
        self.couadField.layer.borderColor = UIColor.groupTableViewBackground.cgColor
        
        let couadLabel = UILabel(frame: CGRect(x: 10, y: 0, width: 100, height: trypeField.frame.size.height))
        couadLabel.style(leftLabelStyle)
        couadLabel.text = "课程地点"
        let couadLView = UIView(frame: CGRect(x: 0, y: 0, width: 150, height: trypeField.frame.size.height))
        couadLView.addSubview(couadLabel)
        self.couadField.leftView = couadLView
        self.couadField.leftViewMode = .always
        
        self.begdaField.layer.borderColor = UIColor.groupTableViewBackground.cgColor
        
        let begdaLabel = UILabel(frame: CGRect(x: 10, y: 0, width: 100, height: couteField.frame.size.height))
        begdaLabel.style(leftLabelStyle)
        begdaLabel.text = "开始日期"
        let begdaLView = UIView(frame: CGRect(x: 0, y: 0, width: 150, height: couteField.frame.size.height))
        begdaLView.addSubview(begdaLabel)
        self.begdaField.leftView = begdaLView
        self.begdaField.leftViewMode = .always
        
        self.enddaField.layer.borderColor = UIColor.groupTableViewBackground.cgColor
        
        let enddaLabel = UILabel(frame: CGRect(x: 10, y: 0, width: 100, height: statusField.frame.size.height))
        enddaLabel.style(leftLabelStyle)
        enddaLabel.text = "结束日期"
        let enddaView = UIView(frame: CGRect(x: 0, y: 0, width: 150, height: statusField.frame.size.height))
        enddaView.addSubview(enddaLabel)
        self.enddaField.leftView = enddaView
        self.enddaField.leftViewMode = .always
        
        btnSend.tap(sign)
        btnCancel.tap(cancel)
    }
    
    func updateUI() {
        counoField.text = courseInfo?.couno
        counaField.text = courseInfo?.couna
        contentsField.text = courseInfo?.coudt
        if courseInfo?.trype == "01" {
            self.trypeField.text = "内部培训"
        } else if courseInfo?.trype == "02" {
            self.trypeField.text = "外部培训"
        }
        couteField.text = courseInfo?.coute
        if courseInfo?.coust == "02" {
            self.statusField.text = "已报名"
        } else if courseInfo?.trype == "03" {
            self.statusField.text = "已取消"
        }
        couadField.text = courseInfo?.couad
        begdaField.text = courseInfo?.begda
        enddaField.text = courseInfo?.endda
        
        counoField.isEnabled = false
        counaField.isEnabled = false
        contentsField.isEditable = false
        trypeField.isEnabled = false
        couteField.isEnabled = false
        statusField.isEnabled = false
        couadField.isEnabled = false
        begdaField.isEnabled = false
        enddaField.isEnabled = false
        
    }
    
    func sign() {
        courseInfo?.coust = "02"
        self.statusField.text = "已报名"
        
        updateCourse()
    }
    
    
    func cancel() {
        courseInfo?.coust = "03"
        self.statusField.text = "已取消"
        
        updateCourse()
    }
    
    func updateCourse() {
        let params = ["PERNR": User.getUserId()!, "BEGDA": courseInfo?.begda, "ENDDA": courseInfo?.endda, "TRYPE": courseInfo?.trype, "COUAD": courseInfo?.couad,
                      "COUDT": courseInfo?.coudt, "COUNA": courseInfo?.couna, "COUNO": courseInfo?.couno, "COUTE": courseInfo?.coute, "COUST": courseInfo?.coust] as Parameters?
        
        SVProgressHUD.show()
        HRMSApi.POST(API_COURSE_UPDATE_INFO, params:params) { (response: HRMSResponse?, error: HRMSError?) in
            SVProgressHUD.dismiss()
            
            guard response != nil else {
                SVProgressHUD.showError(withStatus: error?.message)
                return
            }
            
            if response?.success == -1 {
                SVProgressHUD.showError(withStatus: "发送失败.")
                return
            } else {
                SVProgressHUD.showSuccess(withStatus: "发送成功")
            }
        }
    }
}
