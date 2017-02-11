//
//  TrainingDetailVC.swift
//  HRMS
//
//  Created by Apollo on 2/7/17.
//  Copyright © 2017 Apollo. All rights reserved.
//

import UIKit
import SVProgressHUD

class TrainingDetailVC: BaseInputVC {
    
    @IBOutlet weak var begdaField: UITextField!
    @IBOutlet weak var enddaField: UITextField!
    @IBOutlet weak var typeField: UITextField!
    @IBOutlet weak var nameField: UITextField!
    @IBOutlet weak var resultField: UITextField!
    
    var info: CourseStatusInfo?

    override func viewDidLoad() {
        super.viewDidLoad()
        
        setupUI()

        updateUI()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)

        self.navigationItem.title = "培训信息"//NSLocalizedString("setting", comment: "")
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        self.view.endEditing(true)
    }
    
    func setupUI() {
        self.begdaField.layer.borderColor = UIColor.groupTableViewBackground.cgColor
        
        self.begdaField.leftViewMode = .always
        let leftBegdaLabel = UILabel(frame: CGRect(x: 0, y: 0, width: 120, height: typeField.frame.size.height))
        leftBegdaLabel.style(leftLabelStyle)
        leftBegdaLabel.text = "培训开始日期 :"
        self.begdaField.leftView = leftBegdaLabel
        
        self.enddaField.layer.borderColor = UIColor.groupTableViewBackground.cgColor
        
        self.enddaField.leftViewMode = .always
        let leftEnddaLabel = UILabel(frame: CGRect(x: 0, y: 0, width: 120, height: typeField.frame.size.height))
        leftEnddaLabel.style(leftLabelStyle)
        leftEnddaLabel.text = "培训结束日期 :"
        self.enddaField.leftView = leftEnddaLabel
        
        self.typeField.layer.borderColor = UIColor.groupTableViewBackground.cgColor
        
        self.typeField.leftViewMode = .always
        let leftTypeLabel = UILabel(frame: CGRect(x: 0, y: 0, width: 120, height: typeField.frame.size.height))
        leftTypeLabel.style(leftLabelStyle)
        leftTypeLabel.text = "课 程 类 型 :"
        self.typeField.leftView = leftTypeLabel
        
        self.nameField.layer.borderColor = UIColor.groupTableViewBackground.cgColor
        
        self.nameField.leftViewMode = .always
        let leftNameLabel = UILabel(frame: CGRect(x: 0, y: 0, width: 120, height: typeField.frame.size.height))
        leftNameLabel.style(leftLabelStyle)
        leftNameLabel.text = "课 程 名 称 :"
        self.nameField.leftView = leftNameLabel
        
        self.resultField.layer.borderColor = UIColor.groupTableViewBackground.cgColor
        
        self.resultField.leftViewMode = .always
        let leftResultLabel = UILabel(frame: CGRect(x: 0, y: 0, width: 120, height: typeField.frame.size.height))
        leftResultLabel.style(leftLabelStyle)
        leftResultLabel.text = "课 程 名 称 :"
        self.resultField.leftView = leftResultLabel

    }
    func updateUI() {
        if info == nil {
            return
        }

        self.begdaField.text = info?.begda
        self.enddaField.text = info?.endda
        if info?.trype == "01" {
            self.typeField.text = "内部培训"
        } else if info?.trype == "02" {
            self.typeField.text = "外部培训"
        }
        self.nameField.text = info?.couna
        self.resultField.text = info?.trrst

        self.begdaField.isEnabled = false
        self.enddaField.isEnabled = false
        self.typeField.isEnabled = false
        self.nameField.isEnabled = false
        self.resultField.isEnabled = false
    }
}
