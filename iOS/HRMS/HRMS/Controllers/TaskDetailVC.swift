//
//  TaskDetailVC.swift
//  HRMS
//
//  Created by Apollo on 2/3/17.
//  Copyright © 2017 Apollo. All rights reserved.
//

import UIKit
import Alamofire
import SVProgressHUD

class TaskDetailVC: BaseInputVC, UITextFieldDelegate {
    
    @IBOutlet weak var taskIdField: UITextField!
    @IBOutlet weak var themeField: UITextField!
    @IBOutlet weak var startDateField: UITextField!
    @IBOutlet weak var endDateField: UITextField!
    @IBOutlet weak var addressField: UITextField!
    @IBOutlet weak var contentsField: UITextView!

    @IBOutlet weak var excutionField: UITextView!
    @IBOutlet weak var progressField: UITextField!
    @IBOutlet weak var statusField: UITextField!
    @IBOutlet weak var completionField: UITextView!

    @IBOutlet weak var btnSend: UIButton!
    
    var addressLabel = UILabel()
    
    var memberId: String?
    var approver: String?
    var taskInfo: TaskInfo?
    var viewMode = 1
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        if self.memberId == nil || self.memberId?.isEmpty == true {
            self.memberId = User.getUserId()
        }

        setupUI()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)

        self.navigationItem.title = "任务"//NSLocalizedString("setting", comment: "")
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        self.view.endEditing(true)
    }
    
    func setupUI() {
        self.taskIdField.layer.borderColor = UIColor.groupTableViewBackground.cgColor

        let taskIdLabel = UILabel(frame: CGRect(x: 10, y: 0, width: 100, height: taskIdField.frame.size.height))
        taskIdLabel.style(leftLabelStyle)
        taskIdLabel.text = "任务编号"
        let taskIdView = UIView(frame: CGRect(x: 0, y: 0, width: 150, height: taskIdField.frame.size.height))
        taskIdView.addSubview(taskIdLabel)
        self.taskIdField.leftView = taskIdView
        self.taskIdField.leftViewMode = .always
        
        self.themeField.layer.borderColor = UIColor.groupTableViewBackground.cgColor

        let themeLabel = UILabel(frame: CGRect(x: 10, y: 0, width: 100, height: themeField.frame.size.height))
        themeLabel.style(leftLabelStyle)
        themeLabel.text = "任务主题"
        let themeView = UIView(frame: CGRect(x: 0, y: 0, width: 150, height: themeField.frame.size.height))
        themeView.addSubview(themeLabel)
        self.themeField.leftView = themeView
        self.themeField.leftViewMode = .always
        
        self.startDateField.layer.borderColor = UIColor.groupTableViewBackground.cgColor

        let startDateLabel = UILabel(frame: CGRect(x: 10, y: 0, width: 100, height: startDateField.frame.size.height))
        startDateLabel.style(leftLabelStyle)
        startDateLabel.text = "下达日期"
        let startDateLView = UIView(frame: CGRect(x: 0, y: 0, width: 150, height: startDateField.frame.size.height))
        startDateLView.addSubview(startDateLabel)
        self.startDateField.leftView = startDateLView
        self.startDateField.leftViewMode = .always
        
        let iconStartDate = UIImageView(frame: CGRect(x: 10, y: 10, width: 20, height: 20))
        iconStartDate.image = UIImage(named: "date")
        let startDateView = UIView(frame: CGRect(x: 0, y: 0, width: 40, height: 40))
        startDateView.addSubview(iconStartDate)
        startDateField.rightView = startDateView
        startDateField.rightViewMode = UITextFieldViewMode.always
        
        self.endDateField.layer.borderColor = UIColor.groupTableViewBackground.cgColor

        let endDateLabel = UILabel(frame: CGRect(x: 10, y: 0, width: 100, height: endDateField.frame.size.height))
        endDateLabel.style(leftLabelStyle)
        endDateLabel.text = "规定完成日期"
        let endDateLView = UIView(frame: CGRect(x: 0, y: 0, width: 150, height: endDateField.frame.size.height))
        endDateLView.addSubview(endDateLabel)
        self.endDateField.leftView = endDateLView
        self.endDateField.leftViewMode = .always
        
        let iconEndDate = UIImageView(frame: CGRect(x: 10, y: 10, width: 20, height: 20))
        iconEndDate.image = UIImage(named: "date")
        let endDateView = UIView(frame: CGRect(x: 0, y: 0, width: 40, height: 40))
        endDateView.addSubview(iconEndDate)
        endDateField.rightView = endDateView
        endDateField.rightViewMode = UITextFieldViewMode.always
        
        self.addressField.layer.borderColor = UIColor.groupTableViewBackground.cgColor

        addressLabel = UILabel(frame: CGRect(x: 10, y: 0, width: 100, height: addressField.frame.size.height))
        addressLabel.style(leftLabelStyle)
        addressLabel.text = "执行人员"
        let addressView = UIView(frame: CGRect(x: 0, y: 0, width: 150, height: addressField.frame.size.height))
        addressView.addSubview(addressLabel)
        self.addressField.leftView = addressView
        self.addressField.leftViewMode = .always
        
        let iconAddress = UIImageView(frame: CGRect(x: 10, y: 10, width: 10, height: 20))
        iconAddress.image = UIImage(named: "right")
        let addressRightView = UIView(frame: CGRect(x: 0, y: 0, width: 30, height: 40))
        addressRightView.addSubview(iconAddress)
        addressField.rightView = addressRightView
        addressField.rightViewMode = UITextFieldViewMode.always

        self.contentsField.layer.borderColor = UIColor.groupTableViewBackground.cgColor
        contentsField.placeholder = "任务内容";
        contentsField.placeholderColor = UIColor.lightGray;


        self.excutionField.layer.borderColor = UIColor.groupTableViewBackground.cgColor
        excutionField.placeholder = "任务执行情况";
        excutionField.placeholderColor = UIColor.lightGray;

        self.progressField.layer.borderColor = UIColor.groupTableViewBackground.cgColor

        let progressLabel = UILabel(frame: CGRect(x: 10, y: 0, width: 100, height: progressField.frame.size.height))
        progressLabel.style(leftLabelStyle)
        progressLabel.text = "执行进度"
        let progressView = UIView(frame: CGRect(x: 0, y: 0, width: 150, height: progressField.frame.size.height))
        progressView.addSubview(progressLabel)
        self.progressField.leftView = progressView
        self.progressField.leftViewMode = .always
        
        let percentLabel = UILabel(frame: CGRect(x: 10, y: 0, width: 10, height: progressField.frame.size.height))
        percentLabel.style(leftLabelStyle)
        percentLabel.text = "%"
        let percentView = UIView(frame: CGRect(x: progressField.frame.size.width-30, y: 0, width: 30, height: progressField.frame.size.height))
        percentView.addSubview(percentLabel)
        self.progressField.rightView = percentView
        self.progressField.rightViewMode = .always
        self.progressField.delegate = self

        self.statusField.layer.borderColor = UIColor.groupTableViewBackground.cgColor

        let statusLabel = UILabel(frame: CGRect(x: 10, y: 0, width: 100, height: statusField.frame.size.height))
        statusLabel.style(leftLabelStyle)
        statusLabel.text = "执行状态"
        let statusView = UIView(frame: CGRect(x: 0, y: 0, width: 150, height: statusField.frame.size.height))
        statusView.addSubview(statusLabel)
        self.statusField.leftView = statusView
        self.statusField.leftViewMode = .always

        self.completionField.layer.borderColor = UIColor.groupTableViewBackground.cgColor
        completionField.placeholder = "任务完成情况";
        completionField.placeholderColor = UIColor.lightGray;

        btnSend.tap(send)

        updateUI()
    }
    
    func updateUI() {
        taskIdField.text = taskInfo?.taskId
        themeField.text = taskInfo?.taskTheme
        startDateField.text = taskInfo?.taskStartDate
        endDateField.text = taskInfo?.taskRegulationDate
        addressField.text = taskInfo?.excuteName
        contentsField.text = taskInfo?.taskDetails
        excutionField.text = taskInfo?.excuteDetail
        progressField.text = taskInfo?.excutePlanState
        completionField.text = taskInfo?.completeState
        if taskInfo?.excuteState == "01" {
            statusField.text = "待完成"
        } else if taskInfo?.excuteState == "02" {
            statusField.text = "进行中"
        } else if taskInfo?.excuteState == "03" {
            statusField.text = "已完成"
        } else if taskInfo?.excuteState == "04" {
            statusField.text = "已评估"
        }

        if viewMode == 1 {
            addressLabel.text = "分配人员"
            addressField.text = taskInfo?.fromName
            completionField.isEditable = false
            if taskInfo?.excuteState == "03" || taskInfo?.excuteState == "04" {
                excutionField.isEditable = false
                progressField.isEnabled = false
            } else {
                excutionField.isEditable = true
                progressField.isEnabled = true
            }
        } else {
            addressLabel.text = "执行人员"
            addressField.text = taskInfo?.excuteName
            excutionField.isEditable = false
            progressField.isEnabled = false
            if taskInfo?.excuteState == "01" || taskInfo?.excuteState == "02" {
                completionField.isEditable = false
            } else {
                completionField.isEditable = true
            }
        }
        
        taskIdField.isEnabled = false
        themeField.isEnabled = false
        startDateField.isEnabled = false
        endDateField.isEnabled = false
        addressField.isEnabled = false
        contentsField.isEditable = false
        statusField.isEnabled = false
    }

    func send() {

        let strExcution = excutionField.text
        let strProgress = progressField.text
        let strCompletion = completionField.text

//        if strExcution == nil || strExcution?.isEmpty == true || strProgress == nil || strProgress?.isEmpty == true {//|| strCompletion == nil || strCompletion?.isEmpty == true {
//            let alertController = UIAlertController(title: "错误", message: "任务内容不能为空!", preferredStyle: UIAlertControllerStyle.alert)
//            let okAction = UIAlertAction(title: "确认", style: UIAlertActionStyle.default) {
//                (result : UIAlertAction) -> Void in
//            }
//            
//            alertController.addAction(okAction)
//            self.present(alertController, animated: true, completion: nil)
//            
//        } else {
            var params = ["ID": taskInfo?.id, "OBJID": self.memberId!, "OTYPE": "P", "FROM_MEMBER": taskInfo?.fromMember, "TASK_ID": taskInfo?.taskId,
                          "TASK_THEME": taskInfo?.taskTheme, "TASK_START_DATE": taskInfo?.taskStartDate, "TASK_REGULATION_DATE": taskInfo?.taskCompleteDate,
                          "TASK_DETAILS": taskInfo?.taskDetails, "EXCUTE_MEMBER": taskInfo?.excuteMember, "EXCUTE_DETAIL": strExcution!, "EXCUTE_PLAN_STATE": strProgress!,
                          "EXCUTE_STATE": taskInfo?.excuteState, "COMPLETE_STATE": strCompletion!] //as Parameters?
            
            SVProgressHUD.show()
            HRMSApi.POST(API_SAVE_TASK, params:params) { (response: HRMSResponse?, error: HRMSError?) in
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
//        }
    }
    
    func textField(_ textField: UITextField,
                   shouldChangeCharactersIn range: NSRange,
                   replacementString string: String) -> Bool {
        
        // Create an `NSCharacterSet` set which includes everything *but* the digits
        let inverseSet = NSCharacterSet(charactersIn:"0123456789").inverted
        
        // At every character in this "inverseSet" contained in the string,
        // split the string up into components which exclude the characters
        // in this inverse set
        let components = string.components(separatedBy: inverseSet)
        
        // Rejoin these components
        let filtered = components.joined(separator: "")  // use join("", components) if you are using Swift 1.2
        
        // If the original string is equal to the filtered string, i.e. if no
        // inverse characters were present to be eliminated, the input is valid
        // and the statement returns true; else it returns false
        return string == filtered
    }
}
