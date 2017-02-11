//
//  AppealAbsenceDetailVC.swift
//  HRMS
//
//  Created by Apollo on 2/5/17.
//  Copyright © 2017 Apollo. All rights reserved.
//


import UIKit
import Stevia

class AppealAbsenceDetailVC: BaseAppealDetailVC {
    
    @IBOutlet weak var titleField: UITextField!
    @IBOutlet weak var startDateField: UITextField!
    @IBOutlet weak var endDateField: UITextField!
    @IBOutlet weak var absenceDateField: UITextField!
    @IBOutlet weak var absenceTimeField: UITextField!
    @IBOutlet weak var typeField: UITextField!
    @IBOutlet weak var contentField: UITextView!
    @IBOutlet weak var addressField: UITextField!
    @IBOutlet weak var btnSubmit: UIButton!
    @IBOutlet weak var approvalView: UIView!
    @IBOutlet weak var heightApproval: NSLayoutConstraint!


    var vcType = 0; // 0: absence, 1: overtime


    override func viewDidLoad() {
        super.viewDidLoad()
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

    override func setupUI() {

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
        
        let iconLEndDate = UIImageView(frame: CGRect(x: 10, y: 10, width: 20, height: 20))
        iconLEndDate.image = UIImage(named: "date")
        let endDateLeftView = UIView(frame: CGRect(x: 0, y: 0, width: 40, height: 40))
        endDateLeftView.addSubview(iconLEndDate)
        endDateField.leftView = endDateLeftView
        endDateField.leftViewMode = UITextFieldViewMode.always
        
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
    }
    
    override func updateUI() {

        if vcType == 0 {
            titleField.text = responseData?.workFlow?.name
            addressField.text = responseData?.workFlow?.nachn

            let pt1001 = responseData?.pt1001
            if pt1001 != nil {
                startDateField.text = pt1001?.BEGDA
                endDateField.text = pt1001?.ENDDA
                absenceDateField.text = pt1001?.abday
                absenceTimeField.text = pt1001?.abtim
                contentField.text = pt1001?.abren
                for param in (responseData?.params?.par035)! as [ParamModel] {
                    if param.value == pt1001?.abtyp {
                        typeField.text = param.name
                        break
                    }
                }
            }
        } else {
            titleField.text = responseData?.workFlow?.name
            addressField.text = responseData?.workFlow?.nachn

            let pt1003 = responseData?.pt1003
            if pt1003 != nil {
                startDateField.text = pt1003?.BEGDA
                endDateField.text = pt1003?.ENDDA
                absenceDateField.text = pt1003?.otday
                absenceTimeField.text = pt1003?.ottim
                contentField.text = pt1003?.otren
                for param in (responseData?.params?.par036)! as [ParamModel] {
                    if param.value == pt1003?.ottyp {
                        typeField.text = param.name
                        break
                    }
                }
            }
        }
        
        titleField.isEnabled = false
        startDateField.isEnabled = false
        endDateField.isEnabled = false
        absenceDateField.isEnabled = false
        absenceTimeField.isEnabled = false
        typeField.isEnabled = false
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

                configureEvents()

            } else {
                statusField.isEnabled = false
                approverField.isEnabled = false
                remarkField.isEditable = false
            }
        }

        self.approvalView.layout(rows)
    }
}
