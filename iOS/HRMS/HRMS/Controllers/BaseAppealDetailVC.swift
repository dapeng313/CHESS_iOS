//
//  BaseAppealDetailVC.swift
//  HRMS
//
//  Created by Apollo on 2/9/17.
//  Copyright © 2017 Apollo. All rights reserved.
//


import UIKit
import SVProgressHUD
import Alamofire
import Stevia

class BaseAppealDetailVC: BaseInputVC {
    
    var statusField: UITextField!
    var approverField: UITextField!
    var remarkField: UITextView!
    
    let pickerView = UIPickerView()
    let RESULT = ["通过", "流程完结", "拒绝"]
    let RESULT_ID = ["02", "03", "04"]
    
    var statusId = "02"
    
    var memberId: String?
    var approver: String?
    
    var responseData: BaseAppealResponse?
    var isPostable = false
    
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
        updateUI()
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        self.view.endEditing(true)
    }
    
    func setupUI() {
    }
    
    func updateUI() {
    }
    
    func addApproments() {
    }

    func configureEvents() {
        
        self.statusField.inputView = pickerView
        self.statusField.addTarget(self, action: #selector(self.onStatusEditing), for: UIControlEvents.touchDown)
        self.approverField.addTarget(self, action: #selector(self.onAddressEditing), for: UIControlEvents.touchDown)
    }

    func labelStyle(l: UILabel) {
        l.font = .systemFont(ofSize: 14)
        l.textAlignment = .center
        l.textColor = Colors.primary
        l.backgroundColor = UIColor.groupTableViewBackground
    }
    
    func textFieldStyle(l: UITextField) {
        l.font = .systemFont(ofSize: 14)
        l.textAlignment = .center
        l.textColor = UIColor.darkGray
        l.layer.borderColor = UIColor.lightGray.cgColor
        l.layer.borderWidth = 1
    }
    
    func textViewStyle(l: UITextView) {
        l.font = .systemFont(ofSize: 14)
        l.textAlignment = .left
        l.textColor = UIColor.darkGray
        l.backgroundColor = UIColor.clear
        l.layer.borderColor = UIColor.lightGray.cgColor
        l.layer.borderWidth = 1
    }
    
    func onStatusEditing(_ sender: UITextField) {
        pickerView.isHidden = false
    }
    
    func onAddressEditing(_ sender: UITextField) {
        self.view.endEditing(true)

        let vc = ContactsVC()
        vc.delegate = self
        self.navigationController?.pushViewController(vc, animated: true)
    }
    
    func submitData() {
        let approval = responseData?.approvalList?.popLast()
        let strStatus = statusField.text
        let strApprover = approverField.text
        let strRemark = remarkField.text
        
        if strStatus == nil || strStatus?.isEmpty == true ||
            (strApprover == nil || strApprover?.isEmpty == true || strRemark == nil || strRemark?.isEmpty == true) && statusId != "04" {
            
            let alertController = UIAlertController(title: "错误", message: "申请内容不能为空!", preferredStyle: UIAlertControllerStyle.alert)
            let okAction = UIAlertAction(title: "确认", style: UIAlertActionStyle.default) {
                (result : UIAlertAction) -> Void in
            }
            
            alertController.addAction(okAction)
            self.present(alertController, animated: true, completion: nil)
        } else {
            //let params : Parameters?
            let params = ["memberID": User.getUserId()!, "ROW_ID": approval?.rowId, "FLOWID": approval?.flowId, "REMARK": strRemark, "TYPE": responseData?.workFlow?.type,
                          "APPROVERNA": strApprover, "APPROVER": approver, "STATUS": statusId] as Parameters?
            
            SVProgressHUD.show()
            HRMSApi.POST(API_SAVE_APPROVAL, params: params) { (response: HRMSResponse?, error: HRMSError?) in
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
}

extension BaseAppealDetailVC: UIPickerViewDelegate, UIPickerViewDataSource {
    
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return 1
    }
    
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        return RESULT.count
    }
    
    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        return RESULT[row]
    }
    
    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        self.statusId = RESULT_ID[row]
        if self.statusField != nil {
            self.statusField.text = RESULT[row]
        }
        
        if row == 2 {
            self.approverField.text = ""
            self.remarkField.text = ""
        }
        
        self.view.endEditing(true)
    }
    
}

extension BaseAppealDetailVC: ContactsVCDelegate {
    func onSelectContact(_ vc: ContactsVC, _ itemId: String, _ itemName: String) {
        self.approver = itemId
        if self.approverField != nil {
            self.approverField.text = itemName
        }
        
        self.navigationController?.popViewController(animated: true)
    }
}
