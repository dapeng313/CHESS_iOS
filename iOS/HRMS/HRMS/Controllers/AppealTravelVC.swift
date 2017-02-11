//
//  AppealTravelVC.swift
//  HRMS
//
//  Created by Apollo on 1/29/17.
//  Copyright © 2017 Apollo. All rights reserved.
//

import UIKit
import SVProgressHUD
import Alamofire

class AppealTravelVC: BaseInputVC {
    
    @IBOutlet weak var titleField: UITextField!
    @IBOutlet weak var startDateField: UITextField!
    @IBOutlet weak var endDateField: UITextField!
    @IBOutlet weak var travelDateField: UITextField!
    @IBOutlet weak var travelTimeField: UITextField!
    @IBOutlet weak var startLocationField: UITextField!
    @IBOutlet weak var endLocationField: UITextField!
    @IBOutlet weak var budgetField: UITextField!
    @IBOutlet weak var contentField: UITextView!
    @IBOutlet weak var addressField: UITextField!
    @IBOutlet weak var btnSubmit: UIButton!
    
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
        
        self.navigationItem.title = "出差申请"//NSLocalizedString("setting", comment: "")
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
        travelDateField.layer.borderColor = UIColor.lightGray.cgColor
        travelTimeField.layer.borderColor = UIColor.lightGray.cgColor
        startLocationField.layer.borderColor = UIColor.lightGray.cgColor
        endLocationField.layer.borderColor = UIColor.lightGray.cgColor
        budgetField.layer.borderColor = UIColor.lightGray.cgColor
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
        
        let iconStartLocation = UIImageView(frame: CGRect(x: 10, y: 10, width: 15, height: 20))
        iconStartLocation.image = UIImage(named: "address")
        let startLocLeftView = UIView(frame: CGRect(x: 0, y: 0, width: 40, height: 40))
        startLocLeftView.addSubview(iconStartLocation)
        startLocationField.leftView = startLocLeftView
        startLocationField.leftViewMode = UITextFieldViewMode.always
        
        let iconEndLocation = UIImageView(frame: CGRect(x: 10, y: 10, width: 15, height: 20))
        iconEndLocation.image = UIImage(named: "address")
        let endLocLeftView = UIView(frame: CGRect(x: 0, y: 0, width: 40, height: 40))
        endLocLeftView.addSubview(iconEndLocation)
        endLocationField.leftView = endLocLeftView
        endLocationField.leftViewMode = UITextFieldViewMode.always
        
        let iconLBudget = UIImageView(frame: CGRect(x: 10, y: 10, width: 20, height: 20))
        iconLBudget.image = UIImage(named: "budget")
        let budgetLeftView = UIView(frame: CGRect(x: 0, y: 0, width: 40, height: 40))
        budgetLeftView.addSubview(iconLBudget)
        budgetField.leftView = budgetLeftView
        budgetField.leftViewMode = UITextFieldViewMode.always
        
        let iconLContent = UIImageView(frame: CGRect(x: 10, y: 10, width: 20, height: 20))
        iconLContent.image = UIImage(named: "contents")
        let contentLeftView = UIView(frame: CGRect(x: 0, y: 0, width: 40, height: 40))
        contentLeftView.addSubview(iconLContent)
        //contentField.addSubview(contentLeftView)
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

        btnSubmit.tap(submitData)

        startDateField.removeKeyboardObserver()
        endDateField.removeKeyboardObserver()
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
        let strTravelDate = travelDateField.text
        let strTravelTime = travelTimeField.text
        let strStartLocation = startLocationField.text
        let strEndLocation = endLocationField.text
        let strBudget = budgetField.text
        let strContents = contentField.text
        let strAddress = addressField.text

        if strTitle == nil || strTitle?.isEmpty == true || strStartDate == nil || strStartDate?.isEmpty == true || strEndDate == nil || strEndDate?.isEmpty == true ||
            strTravelDate == nil || strTravelDate?.isEmpty == true || strTravelTime == nil || strTravelTime?.isEmpty == true ||
            strStartLocation == nil || strStartLocation?.isEmpty == true || strEndLocation == nil || strEndLocation?.isEmpty == true ||
            strBudget == nil || strBudget?.isEmpty == true || strContents == nil || strContents?.isEmpty == true || strAddress == nil || strAddress?.isEmpty == true {

            let alertController = UIAlertController(title: "错误", message: "申请内容不能为空!", preferredStyle: UIAlertControllerStyle.alert) //Replace UIAlertControllerStyle.Alert by UIAlertControllerStyle.alert
            // Replace UIAlertActionStyle.Default by UIAlertActionStyle.default
            let okAction = UIAlertAction(title: "确认", style: UIAlertActionStyle.default) {
                (result : UIAlertAction) -> Void in
            }

            alertController.addAction(okAction)
            self.present(alertController, animated: true, completion: nil)
        } else {
            //let params : Parameters?
            let params = ["memberID": self.memberId!, "ROW_ID": 0, "APPROVAL_ROW_ID": 0, "TRAVEL_ROW_ID": 0, "NAME": strTitle,
                                   "BEGDA": strStartDate, "ENDDA": strEndDate, "TRDAY": strTravelDate, "TRTIM": strTravelTime,
                                   "TRSTA": strStartLocation, "TRDES": strEndLocation, "TRBUD": strBudget, "TRREN": strContents,
                                   "APPROVERNA": strAddress, "APPROVER": approver, "STATUS": "02"] as Parameters?

            SVProgressHUD.show()
            HRMSApi.POST(API_SAVE_APPEAL_TRAVEL, params: params) { (response: HRMSResponse?, error: HRMSError?) in
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
}

extension AppealTravelVC: ContactsVCDelegate {
    func onSelectContact(_ vc: ContactsVC, _ itemId: String, _ itemName: String) {
        addressField.text = itemName
        self.approver = itemId

        self.navigationController?.popViewController(animated: true)
    }
}
