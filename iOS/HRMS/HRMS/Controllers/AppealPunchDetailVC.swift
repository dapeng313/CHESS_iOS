//
//  AppealPunchDetailVC.swift
//  HRMS
//
//  Created by Apollo on 2/5/17.
//  Copyright © 2017 Apollo. All rights reserved.
//

import UIKit


import UIKit
import Stevia

class AppealPunchDetailVC: BaseAppealDetailVC {
    
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
    @IBOutlet weak var approvalView: UIView!
    @IBOutlet weak var heightApproval: NSLayoutConstraint!

    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        self.navigationItem.title = "考勤修正申请"//NSLocalizedString("setting", comment: "")
    }
    
    override func setupUI() {
        
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
        
        pickerView.dataSource = self
        pickerView.delegate = self
        pickerView.isHidden = true
    }
    
    override func updateUI() {
        titleField.text = responseData?.workFlow?.name
        contentField.text = responseData?.workFlow?.descript
        addressField.text = responseData?.workFlow?.nachn

        let pt1005 = responseData?.pt1005
        if pt1005 != nil {
            clodaField.text = pt1005?.cloda
            oloinField.text = pt1005?.oloin
            mloinField.text = pt1005?.mloin
            oinadField.text = pt1005?.oinad
            minadField.text = pt1005?.minad
            oloouField.text = pt1005?.oloou
            mloouField.text = pt1005?.mloou
            oouadField.text = pt1005?.oouad
            mouadField.text = pt1005?.mouad
        }
        
        titleField.isEnabled = false
        clodaField.isEnabled = false
        oloinField.isEnabled = false
        mloinField.isEnabled = false
        oinadField.isEnabled = false
        minadField.isEnabled = false
        oloouField.isEnabled = false
        mloouField.isEnabled = false
        oouadField.isEnabled = false
        mouadField.isEnabled = false
        contentField.isEditable = false
        addressField.isEnabled = false

        if isPostable {
            btnSubmit.isHidden = false
        } else {
            btnSubmit.isHidden = true
        }
        
        addApproments()
    }
    
    override func addApproments() {
        let itemCount = (responseData?.approvalList?.count)!
        
        if itemCount <= 0 {
            return
        }
        
        heightApproval.constant = CGFloat(230*itemCount)
        self.approvalView.setNeedsUpdateConstraints()
        self.approvalView.layoutIfNeeded()
        
        var rows = [AnyObject]()
        var posY = 0.0
        for approval in (responseData?.approvalList)! {
            
            // Layout
            let subContainer = UIView()
            
            let borderView = UIView()
            let titleLabel = UILabel()
            let statusField = UITextField()
            let approverField = UITextField()
            let remarkField = UITextView()
            
            self.approvalView.sv(
                subContainer.sv(
                    borderView,
                    titleLabel.style(labelStyle),
                    statusField.style(textFieldStyle),
                    approverField.style(textFieldStyle),
                    remarkField.style(textViewStyle)
                )
            )
            
            borderView.backgroundColor = Colors.primary
            borderView.height(1)
            
            equalWidths(statusField, approverField, remarkField, borderView)
            equalHeights(statusField, approverField)
            
            subContainer.layout(
                10,
                titleLabel.height(20).centerHorizontally(),
                10,
                statusField.height(40).width(self.approvalView.frame.width).centerHorizontally(),
                5,
                approverField.centerHorizontally(),
                5,
                remarkField.height(80).centerHorizontally(),
                10
            )
            borderView.top(20).centerHorizontally()
            
            subContainer.height(220).width(self.approvalView.frame.width).centerHorizontally().top(CGFloat(posY))
            posY += 220
            
            rows.append(|subContainer|)
            
            // UI for subViews
            let statusLabel = UILabel(frame: CGRect(x: 10, y: 0, width: 80, height: 40))
            statusLabel.style(leftLabelStyleBlue)
            statusLabel.text = "审批结果"
            let statusView = UIView(frame: CGRect(x: 0, y: 0, width: 100, height: 40))
            statusView.addSubview(statusLabel)
            statusField.leftView = statusView
            statusField.leftViewMode = .always
            
            let approverLabel = UILabel(frame: CGRect(x: 10, y: 0, width: 80, height: 40))
            approverLabel.style(leftLabelStyleBlue)
            approverLabel.text = "审批人"
            let approverView = UIView(frame: CGRect(x: 0, y: 0, width: 100, height: 40))
            approverView.addSubview(approverLabel)
            approverField.leftView = approverView
            approverField.leftViewMode = .always
            
            remarkField.placeholder = "备注";
            remarkField.placeholderColor = Colors.primary;
            
            // data
            titleLabel.text = " 审批步骤 "
            if approval.state == "02" || approval.state == "03" {
                statusField.text = "通过"
            } else if approval.state == "04" {
                statusField.text = "拒绝"
            }
            approverField.text = approval.approverna
            remarkField.text = approval.remark
            
            // event listener
            if isPostable && responseData?.approvalList?.index(of: approval) == (responseData?.approvalList?.count)!-1 {
                statusField.isEnabled = true
                approverField.isEnabled = true
                remarkField.isEditable = true
                
                self.statusField = statusField
                self.approverField = approverField
                self.remarkField = remarkField
                
                self.statusField.inputView = pickerView
                self.statusField.addTarget(self, action: #selector(self.onStatusEditing), for: UIControlEvents.touchDown)
                self.approverField.addTarget(self, action: #selector(self.onAddressEditing), for: UIControlEvents.touchDown)
            } else {
                statusField.isEnabled = false
                approverField.isEnabled = false
                remarkField.isEditable = false
            }
        }
        
        self.approvalView.layout(rows)
    }
}

