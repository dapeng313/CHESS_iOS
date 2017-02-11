//
//  AppealDailyVC.swift
//  HRMS
//
//  Created by Apollo on 1/30/17.
//  Copyright © 2017 Apollo. All rights reserved.
//

import UIKit
import SVProgressHUD
import Alamofire

class AppealDailyVC: BaseInputVC {
    
    @IBOutlet weak var titleField: UITextField!
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
        
        self.navigationItem.title = "日常申请"//NSLocalizedString("setting", comment: "")
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
        contentField.layer.borderColor = UIColor.lightGray.cgColor
        addressField.layer.borderColor = UIColor.lightGray.cgColor
        
        
        let iconLTitle = UIImageView(frame: CGRect(x: 10, y: 10, width: 20, height: 20))
        iconLTitle.image = UIImage(named: "contents")
        let titleLeftView = UIView(frame: CGRect(x: 0, y: 0, width: 40, height: 40))
        titleLeftView.addSubview(iconLTitle)
        titleField.leftView = titleLeftView
        titleField.leftViewMode = UITextFieldViewMode.always

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
        
        btnSubmit.tap(submitData)
    }

    @IBAction func onAddressEditing(_ sender: UITextField) {
        self.view.endEditing(true)

        let vc = ContactsVC()
        vc.delegate = self
        self.navigationController?.pushViewController(vc, animated: true)
    }

    func submitData() {
        self.view.endEditing(true)
        
        let strTitle = titleField.text
        let strContents = contentField.text
        let strAddress = addressField.text
        
        if strTitle == nil || strTitle?.isEmpty == true || strContents == nil || strContents?.isEmpty == true || strAddress == nil || strAddress?.isEmpty == true {
            
            let alertController = UIAlertController(title: "错误", message: "申请内容不能为空!", preferredStyle: UIAlertControllerStyle.alert) //Replace UIAlertControllerStyle.Alert by UIAlertControllerStyle.alert
            // Replace UIAlertActionStyle.Default by UIAlertActionStyle.default
            let okAction = UIAlertAction(title: "确认", style: UIAlertActionStyle.default) {
                (result : UIAlertAction) -> Void in
            }
            
            alertController.addAction(okAction)
            self.present(alertController, animated: true, completion: nil)
        } else {
            //let params : Parameters?
            let params = ["memberID": self.memberId!, "ROW_ID": 0, "APPROVAL_ROW_ID": 0, "TRAVEL_ROW_ID": 0, "NAME": strTitle, "DESCRIPTION": strContents,
                          "APPROVERNA": strAddress, "APPROVER": approver, "STATUS": "02"] as Parameters?
            
            SVProgressHUD.show()
            HRMSApi.POST(API_SAVE_APPEAL_DAILY, params: params) { (response: HRMSResponse?, error: HRMSError?) in
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

extension AppealDailyVC: ContactsVCDelegate {
    func onSelectContact(_ vc: ContactsVC, _ itemId: String, _ itemName: String) {
        addressField.text = itemName
        self.approver = itemId
        
        self.navigationController?.popViewController(animated: true)
    }
}
