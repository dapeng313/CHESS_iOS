//
//  AppealTravelDetailVC.swift
//  HRMS
//
//  Created by Apollo on 2/6/17.
//  Copyright © 2017 Apollo. All rights reserved.
//


import UIKit
import Stevia

class AppealTravelDetailVC: BaseAppealDetailVC {
    
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
    @IBOutlet weak var approvalView: UIView!
    @IBOutlet weak var heightApproval: NSLayoutConstraint!
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)

        self.navigationItem.title = "出差申请"//NSLocalizedString("setting", comment: "")
    }

    override func setupUI() {
        
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
        
        let iconLEndDate = UIImageView(frame: CGRect(x: 10, y: 10, width: 20, height: 20))
        iconLEndDate.image = UIImage(named: "date")
        let endDateLeftView = UIView(frame: CGRect(x: 0, y: 0, width: 40, height: 40))
        endDateLeftView.addSubview(iconLEndDate)
        endDateField.leftView = endDateLeftView
        endDateField.leftViewMode = UITextFieldViewMode.always
        
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

        pickerView.dataSource = self
        pickerView.delegate = self
        pickerView.isHidden = true
    }
    
    override func updateUI() {
        titleField.text = responseData?.workFlow?.name
        addressField.text = responseData?.workFlow?.nachn

        let pt1002 = responseData?.pt1002
        if pt1002 != nil {
            startDateField.text = pt1002?.BEGDA
            endDateField.text = pt1002?.ENDDA
            travelDateField.text = pt1002?.trday
            travelTimeField.text = pt1002?.trtim
            startLocationField.text = pt1002?.trsta
            endLocationField.text = pt1002?.trdes
            budgetField.text = pt1002?.trbud
            contentField.text = pt1002?.trren

        }
        
        titleField.isEnabled = false
        startDateField.isEnabled = false
        endDateField.isEnabled = false
        travelDateField.isEnabled = false
        travelTimeField.isEnabled = false
        startLocationField.isEnabled = false
        endLocationField.isEnabled = false
        budgetField.isEnabled = false
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
