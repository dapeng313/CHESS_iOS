//
//  NewTaskVC.swift
//  HRMS
//
//  Created by Apollo on 2/2/17.
//  Copyright © 2017 Apollo. All rights reserved.
//

import UIKit
import Alamofire
import SVProgressHUD

class NewTaskVC: BaseInputVC {
    
    @IBOutlet weak var taskIdField: UITextField!
    @IBOutlet weak var themeField: UITextField!
    @IBOutlet weak var startDateField: UITextField!
    @IBOutlet weak var endDateField: UITextField!
    @IBOutlet weak var addressField: UITextField!
    @IBOutlet weak var contentsField: UITextView!
    @IBOutlet weak var btnSend: UIButton!
    
    
    var memberId: String?
    var approver: String?
    var taskInfo: TaskInfo?
    
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
        
        let addressLabel = UILabel(frame: CGRect(x: 10, y: 0, width: 100, height: addressField.frame.size.height))
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
        
        btnSend.tap(send)

        startDateField.removeKeyboardObserver()
        endDateField.removeKeyboardObserver()

        self.getNewTask()
    }

    func updateUI() {
        taskIdField.text = taskInfo?.taskId
        themeField.text = taskInfo?.taskTheme
        startDateField.text = taskInfo?.taskStartDate
        endDateField.text = taskInfo?.taskRegulationDate
        addressField.text = taskInfo?.excuteName
        contentsField.text = taskInfo?.taskDetails

        taskIdField.isEnabled = false
    }
    
    @IBAction func onStartDateEditing(_ sender: UITextField) {
        let datePickerView:UIDatePicker = UIDatePicker()
        datePickerView.datePickerMode = UIDatePickerMode.date
        sender.inputView = datePickerView
        datePickerView.addTarget(self, action: #selector(self.startDatePickerValueChanged), for: UIControlEvents.valueChanged)
        
        if startDateField.text == nil || (startDateField.text?.isEmpty)! {
            startDateField.text = dateFormat.string(from: Date())
        } else {
            datePickerView.date = dateFormat.date(from: startDateField.text!)!
        }
    }
    
    @IBAction func onEndDateEditing(_ sender: UITextField) {
        let datePickerView:UIDatePicker = UIDatePicker()
        datePickerView.datePickerMode = UIDatePickerMode.date
        sender.inputView = datePickerView
        datePickerView.addTarget(self, action: #selector(self.endDatePickerValueChanged), for: UIControlEvents.valueChanged)
        
        if endDateField.text == nil || (endDateField.text?.isEmpty)! {
            endDateField.text = dateFormat.string(from: Date())
        } else {
            datePickerView.date = dateFormat.date(from: endDateField.text!)!
        }
    }
   
    @IBAction func onAddressEditing(_ sender: UITextField) {
        self.view.endEditing(true)

        let vc = ContactsVC()
        vc.delegate = self
        self.navigationController?.pushViewController(vc, animated: true)
    }
    
    func startDatePickerValueChanged(sender:UIDatePicker) {
        startDateField.text = dateFormat.string(from: sender.date)
    }
    
    func endDatePickerValueChanged(sender:UIDatePicker) {
        endDateField.text = dateFormat.string(from: sender.date)
    }
    
    func getNewTask() {
        
        SVProgressHUD.show()
        HRMSApi.POST(API_NEW_TASK, params: ["PERNR": User.getUserId()!]) { (response: NewTaskResponse?, error: HRMSError?) in
            SVProgressHUD.dismiss()
            
            guard response != nil else {
                SVProgressHUD.showError(withStatus: error?.message)
                return
            }
            
            if response?.success == -1 {
                SVProgressHUD.showError(withStatus: "发送失败.")
                return
            }

            self.taskInfo = response?.taskInfo

            self.updateUI()
        }
    }
    
    func send() {
        let strTaskId = taskIdField.text
        let strTheme = themeField.text
        let strStartDate = startDateField.text
        let strEndDate = endDateField.text
        let strAddress = addressField.text
        let strContents = contentsField.text
        
        if strTaskId == nil || strTaskId?.isEmpty == true || strTheme == nil || strTheme?.isEmpty == true ||
            strStartDate == nil || strStartDate?.isEmpty == true || strEndDate == nil || strEndDate?.isEmpty == true ||
            strAddress == nil || strAddress?.isEmpty == true || strContents == nil || strContents?.isEmpty == true {
            let alertController = UIAlertController(title: "错误", message: "任务内容不能为空!", preferredStyle: UIAlertControllerStyle.alert)
            let okAction = UIAlertAction(title: "确认", style: UIAlertActionStyle.default) {
                (result : UIAlertAction) -> Void in
            }
            
            alertController.addAction(okAction)
            self.present(alertController, animated: true, completion: nil)
            
        } else {
            let params = ["ID": strTaskId!, "OBJID": self.memberId!, "OTYPE": "", "FROM_MEMBER": User.getUserId()!, "TASK_ID": taskInfo?.taskId, "TASK_THEME": strTheme!,
                          "TASK_START_DATE": strStartDate!, "TASK_REGULATION_DATE": strEndDate!, "TASK_DETAILS": strContents!, "EXCUTE_MEMBER": strAddress!,
                          "EXCUTE_DETAIL": taskInfo?.excuteDetail, "EXCUTE_PLAN_STATE": taskInfo?.excutePlanState, "EXCUTE_STATE": taskInfo?.excuteState,
                          "COMPLETE_STATE": taskInfo?.completeState] as Parameters?
            
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
        }
    }
}

extension NewTaskVC: ContactsVCDelegate {
    func onSelectContact(_ vc: ContactsVC, _ itemId: String, _ itemName: String) {
        addressField.text = itemName
        self.approver = itemId
        
        self.navigationController?.popViewController(animated: true)
    }
}
