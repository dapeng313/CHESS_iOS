//
//  LogDetailVC.swift
//  HRMS
//
//  Created by Apollo on 1/31/17.
//  Copyright © 2017 Apollo. All rights reserved.
//

import UIKit
import SVProgressHUD
import Alamofire

class LogDetailVC: BaseInputVC {

    @IBOutlet weak var startDateField: UITextField!
    @IBOutlet weak var locationField: UITextView!
    @IBOutlet weak var timeField: UITextView!
    @IBOutlet weak var typeField: UITextView!
    @IBOutlet weak var contentField: UITextView!
    @IBOutlet weak var btnSubmit: UIButton!
    @IBOutlet weak var btnSave: UIButton!
    @IBOutlet weak var btnCancel: UIButton!
    
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
        
        self.navigationItem.title = "新建计划"//NSLocalizedString("setting", comment: "")
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        self.view.endEditing(true)
    }

    func setupUI() {
        
        startDateField.layer.borderColor = UIColor.lightGray.cgColor
        locationField.layer.borderColor = UIColor.lightGray.cgColor
        timeField.layer.borderColor = UIColor.lightGray.cgColor
        typeField.layer.borderColor = UIColor.lightGray.cgColor
        contentField.layer.borderColor = UIColor.lightGray.cgColor
       
        let iconLStartDate = UIImageView(frame: CGRect(x: 10, y: 10, width: 20, height: 20))
        iconLStartDate.image = UIImage(named: "date")
        let startDateLeftView = UIView(frame: CGRect(x: 0, y: 0, width: 40, height: 40))
        startDateLeftView.addSubview(iconLStartDate)
        startDateField.leftView = startDateLeftView
        startDateField.leftViewMode = UITextFieldViewMode.always

        locationField.placeholder = "填写工作地点";
        locationField.placeholderColor = UIColor.lightGray;
        timeField.placeholder = "填写工作时数";
        timeField.placeholderColor = UIColor.lightGray;
        typeField.placeholder = "填写工作性质";
        typeField.placeholderColor = UIColor.lightGray;
        contentField.placeholder = "填写申请内容";
        contentField.placeholderColor = UIColor.lightGray;

        btnSubmit.tap(submitData)
        btnSave.tap(saveData)
        btnCancel.tap(cancel)

        startDateField.removeKeyboardObserver()
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
    
    func startDatePickerValueChanged(sender:UIDatePicker) {
        startDateField.text = dateFormat.string(from: sender.date)
    }
    
    func submitData() {

        let strStartDate = startDateField.text
        let strLocation = locationField.text
        let strTime = timeField.text
        let strType = typeField.text
        let strContents = contentField.text
        
        if strStartDate == nil || strStartDate?.isEmpty == true || strLocation == nil || strLocation?.isEmpty == true ||
            strTime == nil || strTime?.isEmpty == true || strType == nil || strType?.isEmpty == true ||
            strContents == nil || strContents?.isEmpty == true {
            
            let alertController = UIAlertController(title: "错误", message: "内容不能为空!", preferredStyle: UIAlertControllerStyle.alert) //Replace UIAlertControllerStyle.Alert by UIAlertControllerStyle.alert
            // Replace UIAlertActionStyle.Default by UIAlertActionStyle.default
            let okAction = UIAlertAction(title: "确认", style: UIAlertActionStyle.default) {
                (result : UIAlertAction) -> Void in
            }
            
            alertController.addAction(okAction)
            self.present(alertController, animated: true, completion: nil)
        } else {
            //let params : Parameters?
            let params = ["APPLY_ID": self.memberId!, "ROW_ID": 0, "WORK_DATE": strStartDate!, "WORK_HOUR": strTime!, "WORK_PLACE": strLocation!,
                          "WORK_PROPERTY": strType!, "WORK_CONTENT": strContents!, "RELEASE_FLAG": "02"] as Parameters?
            
            SVProgressHUD.show()
            HRMSApi.POST(API_LOG_SAVE_INFO, params: params) { (response: HRMSResponse?, error: HRMSError?) in
                SVProgressHUD.dismiss()
                
                guard response != nil else {
                    SVProgressHUD.showError(withStatus: error?.message)
                    return
                }
                
                if response?.success == -1 {
                    SVProgressHUD.showError(withStatus: "失败.")
                    return
                }

                self.navigationController?.popViewController(animated: true)
            }
        }
    }
    
    func saveData() {
        
        let strStartDate = startDateField.text
        let strLocation = locationField.text
        let strTime = timeField.text
        let strType = typeField.text
        let strContents = contentField.text
        
        if strStartDate == nil || strStartDate?.isEmpty == true || strLocation == nil || strLocation?.isEmpty == true ||
            strTime == nil || strTime?.isEmpty == true || strType == nil || strType?.isEmpty == true ||
            strContents == nil || strContents?.isEmpty == true {
            
            let alertController = UIAlertController(title: "错误", message: "内容不能为空!", preferredStyle: UIAlertControllerStyle.alert) //Replace UIAlertControllerStyle.Alert by UIAlertControllerStyle.alert
            // Replace UIAlertActionStyle.Default by UIAlertActionStyle.default
            let okAction = UIAlertAction(title: "确认", style: UIAlertActionStyle.default) {
                (result : UIAlertAction) -> Void in
            }
            
            alertController.addAction(okAction)
            self.present(alertController, animated: true, completion: nil)
        } else {
            //let params : Parameters?
            let params = ["APPLY_ID": self.memberId!, "ROW_ID": 0, "WORK_DATE": strStartDate!, "WORK_HOUR": strTime!, "WORK_PLACE": strLocation!,
                          "WORK_PROPERTY": strType!, "WORK_CONTENT": strContents!, "RELEASE_FLAG": "01"] as Parameters?
            
            SVProgressHUD.show()
            HRMSApi.POST(API_LOG_SAVE_INFO, params: params) { (response: HRMSResponse?, error: HRMSError?) in
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

            self.navigationController?.popViewController(animated: true)
        }
    }
    
    func cancel() {
        self.navigationController?.popViewController(animated: true)
    }
}
