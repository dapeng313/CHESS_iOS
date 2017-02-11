//
//  AppealAbsenceVC.swift
//  HRMS
//
//  Created by Apollo on 1/30/17.
//  Copyright © 2017 Apollo. All rights reserved.
//

import UIKit
import SVProgressHUD
import Alamofire

class AppealAbsenceVC: BaseInputVC, UIPickerViewDelegate, UIPickerViewDataSource {
    
    @IBOutlet weak var titleField: UITextField!
    @IBOutlet weak var startDateField: UITextField!
    @IBOutlet weak var endDateField: UITextField!
    @IBOutlet weak var absenceDateField: UITextField!
    @IBOutlet weak var absenceTimeField: UITextField!
    @IBOutlet weak var typeField: UITextField!
    @IBOutlet weak var contentField: UITextView!
    @IBOutlet weak var addressField: UITextField!
    @IBOutlet weak var btnSubmit: UIButton!

    let ABSENCE_TYPE = ["事假", "婚假", "产假", "陪护假", "年休假", "工伤假", "病假", "探亲假", "丧假", "哺乳假", "计划生育假", "旷工", "其他"]
    let OVERTIME_TYPE = ["休息日加班", "节假日加班", "夜晚加班", "延时加班"]

    var vcType = 0; // 0: absence, 1: overtime
    let pickerView = UIPickerView()

    var memberId: String?
    var approver: String?
    
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
        
        if vcType != 0 {
            self.navigationItem.title = "加班申请"//NSLocalizedString("setting", comment: "")
        } else {
            self.navigationItem.title = "请假申请"//NSLocalizedString("setting", comment: "")
        }
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        self.view.endEditing(true)
    }

    func setupUI() {
        
        titleField.layer.borderColor = UIColor.lightGray.cgColor
        startDateField.layer.borderColor = UIColor.lightGray.cgColor
        endDateField.layer.borderColor = UIColor.lightGray.cgColor
        absenceDateField.layer.borderColor = UIColor.lightGray.cgColor
        absenceTimeField.layer.borderColor = UIColor.lightGray.cgColor
        typeField.layer.borderColor = UIColor.lightGray.cgColor
        contentField.layer.borderColor = UIColor.lightGray.cgColor
        addressField.layer.borderColor = UIColor.lightGray.cgColor
        
        
        let iconLTitle = UIImageView(frame: CGRect(x: 10, y: 10, width: 20, height: 20))
        iconLTitle.image = UIImage(named: "contents")
        let titleLeftView = UIView(frame: CGRect(x: 0, y: 0, width: 40, height: 40))
        titleLeftView.addSubview(iconLTitle)
        titleField.leftView = titleLeftView
        titleField.leftViewMode = UITextFieldViewMode.always
        
        
        let iconLStartDate = UIImageView(frame: CGRect(x: 10, y: 10, width: 20, height: 20))
        iconLStartDate.image = UIImage(named: "date")
        let startDateLeftView = UIView(frame: CGRect(x: 0, y: 0, width: 40, height: 40))
        startDateLeftView.addSubview(iconLStartDate)
        startDateField.leftView = startDateLeftView
        startDateField.leftViewMode = UITextFieldViewMode.always
        /*
         let iconRStartDate = UIImageView(frame: CGRect(x: 10, y: 10, width: 10, height: 20))
         iconRStartDate.image = UIImage(named: "right")
         let startDateRightView = UIView(frame: CGRect(x: 0, y: 0, width: 30, height: 40))
         startDateRightView.addSubview(iconRStartDate)
         startDateField.rightView = startDateRightView
         startDateField.rightViewMode = UITextFieldViewMode.always
         */
        
        let iconLEndDate = UIImageView(frame: CGRect(x: 10, y: 10, width: 20, height: 20))
        iconLEndDate.image = UIImage(named: "date")
        let endDateLeftView = UIView(frame: CGRect(x: 0, y: 0, width: 40, height: 40))
        endDateLeftView.addSubview(iconLEndDate)
        endDateField.leftView = endDateLeftView
        endDateField.leftViewMode = UITextFieldViewMode.always
        /*
         let iconREndDate = UIImageView(frame: CGRect(x: 10, y: 10, width: 10, height: 20))
         iconREndDate.image = UIImage(named: "right")
         let endDateRightView = UIView(frame: CGRect(x: 0, y: 0, width: 30, height: 40))
         endDateRightView.addSubview(iconREndDate)
         endDateField.rightView = endDateRightView
         endDateField.rightViewMode = UITextFieldViewMode.always
         */
        
        let iconLType = UIImageView(frame: CGRect(x: 10, y: 10, width: 20, height: 20))
        iconLType.image = UIImage(named: "overtime_type")
        let typeLeftView = UIView(frame: CGRect(x: 0, y: 0, width: 40, height: 40))
        typeLeftView.addSubview(iconLType)
        typeField.leftView = typeLeftView
        typeField.leftViewMode = UITextFieldViewMode.always
        
        let iconLContent = UIImageView(frame: CGRect(x: 10, y: 10, width: 20, height: 20))
        iconLContent.image = UIImage(named: "contents")
        let contentLeftView = UIView(frame: CGRect(x: 0, y: 0, width: 40, height: 40))
        contentLeftView.addSubview(iconLContent)
        //contentField.leftView = contentLeftView
        //contentField.leftViewMode = UITextFieldViewMode.always
        contentField.placeholder = "填写申请内容";
        contentField.placeholderColor = UIColor.lightGray;
        
        
        let iconLApprover = UIImageView(frame: CGRect(x: 10, y: 10, width: 20, height: 20))
        iconLApprover.image = UIImage(named: "approver")
        let approverLeftView = UIView(frame: CGRect(x: 0, y: 0, width: 40, height: 40))
        approverLeftView.addSubview(iconLApprover)
        addressField.leftView = approverLeftView
        addressField.leftViewMode = UITextFieldViewMode.always
        
        let iconRApprover = UIImageView(frame: CGRect(x: 10, y: 10, width: 10, height: 20))
        iconRApprover.image = UIImage(named: "right")
        let approverRightView = UIView(frame: CGRect(x: 0, y: 0, width: 30, height: 40))
        approverRightView.addSubview(iconRApprover)
        addressField.rightView = approverRightView
        addressField.rightViewMode = UITextFieldViewMode.always

        if vcType != 0 {
            typeField.placeholder = "选择加班类型"
            absenceDateField.placeholder = "加班天数为"
            absenceTimeField.placeholder = "加班时数为"
        } else {
            typeField.placeholder = "选择请假类型"
            absenceDateField.placeholder = "请假天数为"
            absenceTimeField.placeholder = "请假时数为"
        }

        btnSubmit.tap(submitData)

        pickerView.dataSource = self
        pickerView.delegate = self
        pickerView.isHidden = true
        typeField.inputView = pickerView
        typeField.removeKeyboardObserver()
        startDateField.removeKeyboardObserver()
        endDateField.removeKeyboardObserver()
    }

    @IBAction func onTypeEditing(_ sender: UITextField) {
        pickerView.isHidden = false
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
    
    func submitData() {
        self.view.endEditing(true)
        
        let strTitle = titleField.text
        let strStartDate = startDateField.text
        let strEndDate = endDateField.text
        let strAbsenceDate = absenceDateField.text
        let strAbsenceTime = absenceTimeField.text
        let strType = typeField.text
        let strContents = contentField.text
        let strAddress = addressField.text
        
        if strTitle == nil || strTitle?.isEmpty == true || strStartDate == nil || strStartDate?.isEmpty == true || strEndDate == nil || strEndDate?.isEmpty == true ||
            strAbsenceDate == nil || strAbsenceDate?.isEmpty == true || strAbsenceTime == nil || strAbsenceTime?.isEmpty == true ||
            strType == nil || strType?.isEmpty == true || strContents == nil || strContents?.isEmpty == true || strAddress == nil || strAddress?.isEmpty == true {
            
            let alertController = UIAlertController(title: "错误", message: "申请内容不能为空!", preferredStyle: UIAlertControllerStyle.alert) //Replace UIAlertControllerStyle.Alert by UIAlertControllerStyle.alert
            // Replace UIAlertActionStyle.Default by UIAlertActionStyle.default
            let okAction = UIAlertAction(title: "确认", style: UIAlertActionStyle.default) {
                (result : UIAlertAction) -> Void in
            }
            
            alertController.addAction(okAction)
            self.present(alertController, animated: true, completion: nil)
        } else {
            let params : Parameters?
            if vcType != 0 {
                params = ["memberID": self.memberId!, "ROW_ID": 0, "APPROVAL_ROW_ID": 0, "OVERTIME_ROW_ID": 0, "NAME": strTitle,
                          "BEGDA": strStartDate, "ENDDA": strEndDate, "OTDAY": strAbsenceDate, "OTTIM": strAbsenceTime,
                          "OTTYP": strType, "OTREN": strContents,
                          "APPROVERNA": strAddress, "APPROVER": approver, "STATUS": "02"] as Parameters?
            } else {
                params = ["memberID": self.memberId!, "ROW_ID": 0, "APPROVAL_ROW_ID": 0, "LEAVE_ROW_ID": 0, "NAME": strTitle,
                          "BEGDA": strStartDate, "ENDDA": strEndDate, "ABDAY": strAbsenceDate, "ABTIM": strAbsenceTime,
                          "ABTYP": strType, "ABREN": strContents,
                          "APPROVERNA": strAddress, "APPROVER": approver, "STATUS": "02"] as Parameters?
            }
            
            SVProgressHUD.show()
            HRMSApi.POST(API_SAVE_APPEAL_LEAVE, params: params) { (response: HRMSResponse?, error: HRMSError?) in
                SVProgressHUD.dismiss()
                
                guard response != nil else {
                    SVProgressHUD.showError(withStatus: error?.message)
                    return
                }
                
                if response?.success == -1 {
                    SVProgressHUD.showError(withStatus: "失败.")
                    return
                }
            }
        }
    }

    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return 1
    }

    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        if vcType != 0 {
            return OVERTIME_TYPE.count
        }
        return ABSENCE_TYPE.count
    }
    
    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        if vcType != 0 {
            return OVERTIME_TYPE[row]
        }
        return ABSENCE_TYPE[row]
    }
    
    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        if vcType != 0 {
            self.typeField.text = OVERTIME_TYPE[row]
        }
        self.typeField.text = ABSENCE_TYPE[row]

        self.view.endEditing(true)
    }
}

extension AppealAbsenceVC: ContactsVCDelegate {
    func onSelectContact(_ vc: ContactsVC, _ itemId: String, _ itemName: String) {
        addressField.text = itemName
        self.approver = itemId
        
        self.navigationController?.popViewController(animated: true)
    }
}
