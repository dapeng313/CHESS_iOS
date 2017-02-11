//
//  SalaryDetailVC.swift
//  HRMS
//
//  Created by Apollo on 1/30/17.
//  Copyright © 2017 Apollo. All rights reserved.
//

import UIKit


class SalaryCell: UITableViewCell {
    @IBOutlet weak var nameLabel: UILabel!
    @IBOutlet weak var valueLabel: UILabel!
}


class SalaryDetailVC: UIViewController, UITableViewDataSource, UITableViewDelegate {

    @IBOutlet var tableView: UITableView!
    
    let salaryCellIdentifier = "SalaryCell"

    let TITLE_DETAIL = ["基本工资", "绩效工资", "补助补贴", "加班工资", "其他税前工资", "其他税后工资", "补发工资", "月度奖金", "季度奖金", "年度奖金", "年终奖金（分摊）", "合计"]
    let TITLE_INSURANCE_1 = ["养老保险个人", "医疗保险个人", "失业保险个人", "住房公积金个人", "合计"]
    let TITLE_INSURANCE_2 = ["养老保险公司", "医疗保险公司", "失业保险公司", "工伤保险公司", "生育保险公司", "住房公积金公司", "合计"]
    let TITLE_OTHER = ["缺勤扣款", "代扣款", "其他扣款", "补扣工资", "合计"]
    
    var salaryType = 0 // 0: detail, 1: Insurance, 2: - , 3: other

    var salaryData = [Double]()
    var salaryData2 = [Double]()

    override func viewDidLoad() {
        super.viewDidLoad()

        tableView.delegate = self
        tableView.dataSource = self
        tableView.allowsSelection = false
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        self.navigationController!.setNavigationBarHidden(false, animated: true)
        self.navigationItem.backBarButtonItem = UIBarButtonItem(title: "", style: .plain, target: nil, action: nil)
        
        if salaryType == 0 {
            self.navigationItem.title = "加班申请"//NSLocalizedString("setting", comment: "")
        } else if salaryType == 1 {
            self.navigationItem.title = "请假申请"//NSLocalizedString("setting", comment: "")
        } else {
            self.navigationItem.title = "加班申请"//NSLocalizedString("setting", comment: "")
        }
        
        self.navigationController?.navigationBar.frame = CGRect(x: 0, y: 0, width: (self.view.frame.width), height: 75)
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    // MARK:  UITextFieldDelegate Methods
    func numberOfSections(in tableView: UITableView) -> Int {
        if salaryType == 1 {
            return 2
        } else {
            return 1
        }
    }

    func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        
        if salaryType == 1 {
            if section == 0 {
                return "个人缴纳"
            } else {
                return "公司缴纳"
            }
        } else {
            return nil
        }
    }

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if salaryType == 0 {
            return TITLE_DETAIL.count
        } else if salaryType == 1 {
            if section == 0 {
                return TITLE_INSURANCE_1.count
            } else {
                return TITLE_INSURANCE_2.count
            }
        } else {
            return TITLE_OTHER.count
        }
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: salaryCellIdentifier, for: indexPath as IndexPath) as! SalaryCell

        let row = indexPath.row
        var count = 0

        if salaryType == 0 {
            cell.nameLabel.text = TITLE_DETAIL[row]
            cell.valueLabel.text = String(salaryData[row])
            count = TITLE_DETAIL.count
        } else if salaryType == 1 {
            if indexPath.section == 0 {
                cell.nameLabel.text = TITLE_INSURANCE_1[row]
                cell.valueLabel.text = String(salaryData[row])
                count = TITLE_INSURANCE_1.count
            } else {
                cell.nameLabel.text = TITLE_INSURANCE_2[row]
                cell.valueLabel.text = String(salaryData2[row])
                count = TITLE_INSURANCE_2.count
            }
        } else {
            cell.nameLabel.text = TITLE_OTHER[row]
            cell.valueLabel.text = String(salaryData[row])
            count = TITLE_OTHER.count
        }

        if row >= count-1 {
            cell.nameLabel.textColor = UIColor.red
            cell.valueLabel.textColor = UIColor.red
        } else {
            cell.nameLabel.textColor = UIColor.darkGray
            cell.valueLabel.textColor = UIColor.darkGray
        }
        
        return cell
    }
    
    // MARK:  UITableViewDelegate Methods
    func tableView(_ tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
    }
}
