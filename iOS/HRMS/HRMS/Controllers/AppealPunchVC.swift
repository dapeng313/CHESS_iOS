//
//  AppealPunchVC.swift
//  HRMS
//
//  Created by Apollo on 1/30/17.
//  Copyright © 2017 Apollo. All rights reserved.
//

import UIKit


import UIKit
import SVProgressHUD
import Alamofire

class AppealPunchVC: BaseInputVC {
    
    @IBOutlet weak var titleField: UITextField!
    @IBOutlet weak var clodaField: UITextField!
    @IBOutlet weak var oloinField: UITextField!
    @IBOutlet weak var mloinField: UITextField!
    @IBOutlet weak var oinadField: UITextField!
    @IBOutlet weak var minadField: UITextField!
    @IBOutlet weak var oloouField: UITextField!
    @IBOutlet weak var mloouField: UITextField!
    @IBOutlet weak var oouadField: UITextField!
    @IBOutlet weak var mouadField: UITextField!
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
        
        self.navigationItem.title = "考勤修正申请"//NSLocalizedString("setting", comment: "")
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
        clodaField.layer.borderColor = UIColor.lightGray.cgColor
        oloinField.layer.borderColor = UIColor.lightGray.cgColor
        mloinField.layer.borderColor = UIColor.lightGray.cgColor
        oinadField.layer.borderColor = UIColor.lightGray.cgColor
        minadField.layer.borderColor = UIColor.lightGray.cgColor
        oloouField.layer.borderColor = UIColor.lightGray.cgColor
        mloouField.layer.borderColor = UIColor.lightGray.cgColor
        oouadField.layer.borderColor = UIColor.lightGray.cgColor
        mouadField.layer.borderColor = UIColor.lightGray.cgColor
        contentField.layer.borderColor = UIColor.lightGray.cgColor
        addressField.layer.borderColor = UIColor.lightGray.cgColor
        
        
        let iconLTitle = UIImageView(frame: CGRect(x: 10, y: 10, width: 20, height: 20))
        iconLTitle.image = UIImage(named: "contents")
        let titleLeftView = UIView(frame: CGRect(x: 0, y: 0, width: 40, height: 40))
        titleLeftView.addSubview(iconLTitle)
        titleField.leftView = titleLeftView
        titleField.leftViewMode = UITextFieldViewMode.always
        
        let iconLCloda = UIImageView(frame: CGRect(x: 10, y: 10, width: 20, height: 20))
        iconLCloda.image = UIImage(named: "date")
        let clodaLeftView = UIView(frame: CGRect(x: 0, y: 0, width: 40, height: 40))
        clodaLeftView.addSubview(iconLCloda)
        clodaField.leftView = clodaLeftView
        clodaField.leftViewMode = UITextFieldViewMode.always

        let iconRCloda = UIImageView(frame: CGRect(x: 10, y: 10, width: 10, height: 20))
        iconRCloda.image = UIImage(named: "right")
        let clodaRightView = UIView(frame: CGRect(x: 0, y: 0, width: 30, height: 40))
        clodaRightView.addSubview(iconRCloda)
        clodaField.rightView = clodaRightView
        clodaField.rightViewMode = UITextFieldViewMode.always
        
        let iconLoloin = UIImageView(frame: CGRect(x: 10, y: 10, width: 20, height: 20))
        iconLoloin.image = UIImage(named: "date")
        let oloinLeftView = UIView(frame: CGRect(x: 0, y: 0, width: 40, height: 40))
        oloinLeftView.addSubview(iconLoloin)
        oloinField.leftView = oloinLeftView
        oloinField.leftViewMode = UITextFieldViewMode.always

        let iconRoloin = UIImageView(frame: CGRect(x: 10, y: 10, width: 10, height: 20))
        iconRoloin.image = UIImage(named: "right")
        let oloinRightView = UIView(frame: CGRect(x: 0, y: 0, width: 30, height: 40))
        oloinRightView.addSubview(iconRoloin)
        oloinField.rightView = oloinRightView
        oloinField.rightViewMode = UITextFieldViewMode.always
        
        let iconLmloin = UIImageView(frame: CGRect(x: 10, y: 10, width: 20, height: 20))
        iconLmloin.image = UIImage(named: "date")
        let mloinLeftView = UIView(frame: CGRect(x: 0, y: 0, width: 40, height: 40))
        mloinLeftView.addSubview(iconLmloin)
        mloinField.leftView = mloinLeftView
        mloinField.leftViewMode = UITextFieldViewMode.always
        
        let iconRmloin = UIImageView(frame: CGRect(x: 10, y: 10, width: 10, height: 20))
        iconRmloin.image = UIImage(named: "right")
        let mloinRightView = UIView(frame: CGRect(x: 0, y: 0, width: 30, height: 40))
        mloinRightView.addSubview(iconRmloin)
        mloinField.rightView = mloinRightView
        mloinField.rightViewMode = UITextFieldViewMode.always
        
        let iconoinad = UIImageView(frame: CGRect(x: 10, y: 10, width: 15, height: 20))
        iconoinad.image = UIImage(named: "address")
        let startLocLeftView = UIView(frame: CGRect(x: 0, y: 0, width: 40, height: 40))
        startLocLeftView.addSubview(iconoinad)
        oinadField.leftView = startLocLeftView
        oinadField.leftViewMode = UITextFieldViewMode.always
        
        let iconminad = UIImageView(frame: CGRect(x: 10, y: 10, width: 15, height: 20))
        iconminad.image = UIImage(named: "address")
        let endLocLeftView = UIView(frame: CGRect(x: 0, y: 0, width: 40, height: 40))
        endLocLeftView.addSubview(iconminad)
        minadField.leftView = endLocLeftView
        minadField.leftViewMode = UITextFieldViewMode.always

        
        let iconLoloou = UIImageView(frame: CGRect(x: 10, y: 10, width: 20, height: 20))
        iconLoloou.image = UIImage(named: "date")
        let oloouLeftView = UIView(frame: CGRect(x: 0, y: 0, width: 40, height: 40))
        oloouLeftView.addSubview(iconLoloou)
        oloouField.leftView = oloouLeftView
        oloouField.leftViewMode = UITextFieldViewMode.always
        
        let iconRoloou = UIImageView(frame: CGRect(x: 10, y: 10, width: 10, height: 20))
        iconRoloou.image = UIImage(named: "right")
        let oloouRightView = UIView(frame: CGRect(x: 0, y: 0, width: 30, height: 40))
        oloouRightView.addSubview(iconRoloou)
        oloouField.rightView = oloouRightView
        oloouField.rightViewMode = UITextFieldViewMode.always
        
        let iconLmloou = UIImageView(frame: CGRect(x: 10, y: 10, width: 20, height: 20))
        iconLmloou.image = UIImage(named: "date")
        let mloouLeftView = UIView(frame: CGRect(x: 0, y: 0, width: 40, height: 40))
        mloouLeftView.addSubview(iconLmloou)
        mloouField.leftView = mloouLeftView
        mloouField.leftViewMode = UITextFieldViewMode.always
        
        let iconRmloou = UIImageView(frame: CGRect(x: 10, y: 10, width: 10, height: 20))
        iconRmloou.image = UIImage(named: "right")
        let mloouRightView = UIView(frame: CGRect(x: 0, y: 0, width: 30, height: 40))
        mloouRightView.addSubview(iconRmloou)
        mloouField.rightView = mloouRightView
        mloouField.rightViewMode = UITextFieldViewMode.always
        
        let iconoouad = UIImageView(frame: CGRect(x: 10, y: 10, width: 15, height: 20))
        iconoouad.image = UIImage(named: "address")
        let oouadLeftView = UIView(frame: CGRect(x: 0, y: 0, width: 40, height: 40))
        oouadLeftView.addSubview(iconoouad)
        oouadField.leftView = oouadLeftView
        oouadField.leftViewMode = UITextFieldViewMode.always
        
        let iconmouad = UIImageView(frame: CGRect(x: 10, y: 10, width: 15, height: 20))
        iconmouad.image = UIImage(named: "address")
        let mouadLeftView = UIView(frame: CGRect(x: 0, y: 0, width: 40, height: 40))
        mouadLeftView.addSubview(iconmouad)
        mouadField.leftView = mouadLeftView
        mouadField.leftViewMode = UITextFieldViewMode.always
        
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

        clodaField.removeKeyboardObserver()
        oloinField.removeKeyboardObserver()
        mloinField.removeKeyboardObserver()
        oloouField.removeKeyboardObserver()
        mloouField.removeKeyboardObserver()
    }
    
    @IBAction func onAddressEditing(_ sender: UITextField) {
        self.view.endEditing(true)

        let vc = ContactsVC()
        vc.delegate = self
        self.navigationController?.pushViewController(vc, animated: true)
    }
    
    @IBAction func onClodaEditing(_ sender: UITextField) {
        let datePickerView:UIDatePicker = UIDatePicker()
        datePickerView.datePickerMode = UIDatePickerMode.date
        sender.inputView = datePickerView
        datePickerView.addTarget(self, action: #selector(self.coldaPickerValueChanged), for: UIControlEvents.valueChanged)
        
        if clodaField.text == nil || (clodaField.text?.isEmpty)! {
            clodaField.text = dateFormat.string(from: Date())
        } else {
            datePickerView.date = dateFormat.date(from: clodaField.text!)!
        }
    }
    
    @IBAction func onOloinEditing(_ sender: UITextField) {
        let datePickerView:UIDatePicker = UIDatePicker()
        datePickerView.datePickerMode = UIDatePickerMode.date
        sender.inputView = datePickerView
        datePickerView.addTarget(self, action: #selector(self.oloinPickerValueChanged), for: UIControlEvents.valueChanged)
        
        if oloinField.text == nil || (oloinField.text?.isEmpty)! {
            oloinField.text = dateFormat.string(from: Date())
        } else {
            datePickerView.date = dateFormat.date(from: oloinField.text!)!
        }
    }
    
    @IBAction func onMloinEditing(_ sender: UITextField) {
        let datePickerView:UIDatePicker = UIDatePicker()
        datePickerView.datePickerMode = UIDatePickerMode.date
        sender.inputView = datePickerView
        datePickerView.addTarget(self, action: #selector(self.mloinPickerValueChanged), for: UIControlEvents.valueChanged)
        
        if mloinField.text == nil || (mloinField.text?.isEmpty)! {
            mloinField.text = dateFormat.string(from: Date())
        } else {
            datePickerView.date = dateFormat.date(from: mloinField.text!)!
        }
    }
    
    @IBAction func onOloouEditing(_ sender: UITextField) {
        let datePickerView:UIDatePicker = UIDatePicker()
        datePickerView.datePickerMode = UIDatePickerMode.date
        sender.inputView = datePickerView
        datePickerView.addTarget(self, action: #selector(self.oloouPickerValueChanged), for: UIControlEvents.valueChanged)
        
        if oloouField.text == nil || (oloouField.text?.isEmpty)! {
            oloouField.text = dateFormat.string(from: Date())
        } else {
            datePickerView.date = dateFormat.date(from: oloouField.text!)!
        }
    }
    
    @IBAction func onMloouEditing(_ sender: UITextField) {
        let datePickerView:UIDatePicker = UIDatePicker()
        datePickerView.datePickerMode = UIDatePickerMode.date
        sender.inputView = datePickerView
        datePickerView.addTarget(self, action: #selector(self.mloouPickerValueChanged), for: UIControlEvents.valueChanged)
        
        if mloouField.text == nil || (mloouField.text?.isEmpty)! {
            mloouField.text = dateFormat.string(from: Date())
        } else {
            datePickerView.date = dateFormat.date(from: mloouField.text!)!
        }
    }
    
    func coldaPickerValueChanged(sender:UIDatePicker) {
        clodaField.text = dateFormat.string(from: sender.date)
    }
    
    func oloinPickerValueChanged(sender:UIDatePicker) {
        oloinField.text = dateFormat.string(from: sender.date)
    }
    
    func mloinPickerValueChanged(sender:UIDatePicker) {
        mloinField.text = dateFormat.string(from: sender.date)
    }
    
    func oloouPickerValueChanged(sender:UIDatePicker) {
        oloouField.text = dateFormat.string(from: sender.date)
    }
    
    func mloouPickerValueChanged(sender:UIDatePicker) {
        mloouField.text = dateFormat.string(from: sender.date)
    }
    
    func submitData() {
        self.view.endEditing(true)
        
        let strTitle = titleField.text
        let strCloda = clodaField.text
        let strOloin = oloinField.text
        let strMloin = mloinField.text
        let strOinad = oinadField.text
        let strMinad = minadField.text
        let strOloou = oloouField.text
        let strMloou = mloouField.text
        let strOouad = oouadField.text
        let strMouad = mouadField.text
        let strContents = contentField.text
        let strAddress = addressField.text
        
        if strTitle == nil || strTitle?.isEmpty == true || strCloda == nil || strCloda?.isEmpty == true || strOloin == nil || strOloin?.isEmpty == true ||
            strMloin == nil || strMloin?.isEmpty == true || strOinad == nil || strOinad?.isEmpty == true || strMinad == nil || strMinad?.isEmpty == true ||
            strOloou == nil || strOloou?.isEmpty == true || strMloou == nil || strMloou?.isEmpty == true ||
            strOouad == nil || strOouad?.isEmpty == true || strMouad == nil || strMouad?.isEmpty == true ||
            strContents == nil || strContents?.isEmpty == true || strAddress == nil || strAddress?.isEmpty == true {
            
            let alertController = UIAlertController(title: "错误", message: "申请内容不能为空!", preferredStyle: UIAlertControllerStyle.alert) //Replace UIAlertControllerStyle.Alert by UIAlertControllerStyle.alert
            // Replace UIAlertActionStyle.Default by UIAlertActionStyle.default
            let okAction = UIAlertAction(title: "确认", style: UIAlertActionStyle.default) {
                (result : UIAlertAction) -> Void in
            }
            
            alertController.addAction(okAction)
            self.present(alertController, animated: true, completion: nil)
        } else {
            //let params : Parameters?
            let params = ["memberID": self.memberId!, "ROW_ID": 0, "APPROVAL_ROW_ID": 0, "PUNCH_ROW_ID": 0, "NAME": strTitle,
                          "CLODA": strCloda, "OLOIN": strOloin, "MLOIN": strMloin, "OINAD": strOinad,
                          "MINAD": strMinad, "OLOOU": strOloou, "MLOOU": strMloou, "OOUAD": strOouad,
                          "MOUAD": strMouad, "DESCRIPTION": strContents,
                          "APPROVERNA": strAddress, "APPROVER": approver, "STATUS": "02"] as Parameters?
            
            SVProgressHUD.show()
            HRMSApi.POST(API_SAVE_APPEAL_PUNCH, params: params) { (response: HRMSResponse?, error: HRMSError?) in
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

extension AppealPunchVC: ContactsVCDelegate {
    func onSelectContact(_ vc: ContactsVC, _ itemId: String, _ itemName: String) {
        addressField.text = itemName
        self.approver = itemId
        
        self.navigationController?.popViewController(animated: true)
    }
}

