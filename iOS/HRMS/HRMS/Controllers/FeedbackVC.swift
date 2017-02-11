//
//  FeedbackVC.swift
//  HRMS
//
//  Created by Apollo on 1/31/17.
//  Copyright © 2017 Apollo. All rights reserved.
//

import UIKit
import SVProgressHUD

class FeedbackVC: BaseInputVC {

    @IBOutlet weak var nameField: UITextField!
    @IBOutlet weak var companyField: UITextField!
    @IBOutlet weak var phoneField: UITextField!
    @IBOutlet weak var mailField: UITextField!
    @IBOutlet weak var contentsField: UITextView!

    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setupUI()
        
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)

        self.navigationItem.rightBarButtonItem = UIBarButtonItem(title: "发送", style: .plain, target: self, action: #selector(send))
        
        self.navigationItem.title = "意见与反馈"//NSLocalizedString("setting", comment: "")
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        self.view.endEditing(true)
    }

    func setupUI() {
        self.nameField.layer.borderColor = UIColor.groupTableViewBackground.cgColor

        self.nameField.leftViewMode = .always
        let leftNameLabel = UILabel(frame: CGRect(x: 0, y: 0, width: 100, height: phoneField.frame.size.height))
        leftNameLabel.style(leftLabelStyle)
        leftNameLabel.text = "问题反馈人 :"
        self.nameField.leftView = leftNameLabel
        self.nameField.text = throwEmpty(User.getUserNachn())

        self.companyField.layer.borderColor = UIColor.groupTableViewBackground.cgColor

        self.companyField.leftViewMode = .always
        let leftCompLabel = UILabel(frame: CGRect(x: 0, y: 0, width: 80, height: phoneField.frame.size.height))
        leftCompLabel.style(leftLabelStyle)
        leftCompLabel.text = "所在公司 :"
        self.companyField.leftView = leftCompLabel
        self.companyField.text = throwEmpty(User.getUserConame())

        self.phoneField.layer.borderColor = UIColor.groupTableViewBackground.cgColor

        self.phoneField.leftViewMode = .always
        let leftPhoneLabel = UILabel(frame: CGRect(x: 0, y: 0, width: 80, height: phoneField.frame.size.height))
        leftPhoneLabel.style(leftLabelStyle)
        leftPhoneLabel.text = "手 机 :"
        self.phoneField.leftView = leftPhoneLabel

        self.mailField.layer.borderColor = UIColor.groupTableViewBackground.cgColor

        self.mailField.leftViewMode = .always
        let leftMailLabel = UILabel(frame: CGRect(x: 0, y: 0, width: 80, height: phoneField.frame.size.height))
        leftMailLabel.style(leftLabelStyle)
        leftMailLabel.text = "邮 箱 :"
        self.mailField.leftView = leftMailLabel
        self.mailField.text = throwEmpty(User.getUserEmail())

        self.contentsField.layer.borderColor = UIColor.groupTableViewBackground.cgColor
        contentsField.placeholder = "为了第一时间帮助您解决问题，建议您留下邮箱或QQ号，参数感谢有您一路相伴。";
        contentsField.placeholderColor = UIColor.lightGray;
    }

    func send() {
        let strName = nameField.text
        let strCompany = companyField.text
        let strPhoneNum = phoneField.text
        let strMail = mailField.text
        var strContents = contentsField.text

        if strName == nil || strName?.isEmpty == true || strCompany == nil || strCompany?.isEmpty == true ||
            strPhoneNum == nil || strPhoneNum?.isEmpty == true || strMail == nil || strMail?.isEmpty == true {
            let alertController = UIAlertController(title: "错误", message: "手机号码不能为空!", preferredStyle: UIAlertControllerStyle.alert)
            let okAction = UIAlertAction(title: "确认", style: UIAlertActionStyle.default) {
                (result : UIAlertAction) -> Void in
            }
            
            alertController.addAction(okAction)
            self.present(alertController, animated: true, completion: nil)

        } else {
            
            if strContents == nil {
                strContents = ""
            }
            let str1 = "问题反馈人: "+strName!+"\n所在公司: "+strCompany!
            let str2 = "\n手机: "+strPhoneNum!+"\n邮箱: "+strMail!
            let str3 = "\n\n"+strContents!
            let contents =  str1+str2+str3 //"问题反馈人: "+strName+"\n所在公司: "+strCompany+"\n手机: "+strPhoneNum+"\n邮箱: "+strMail+"\n\n"+strContents
            
            SVProgressHUD.show()
            HRMSApi.POST(API_SEND_EMAIL, params: ["memberID": User.getUserId()!, "TITLE": "意见与反馈", "CONTENT": contents]) { (response: HRMSResponse?, error: HRMSError?) in
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
