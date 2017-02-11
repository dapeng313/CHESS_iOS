//
//  ApprovalVC.swift
//  HRMS
//
//  Created by Apollo on 2/3/17.
//  Copyright © 2017 Apollo. All rights reserved.
//



import UIKit
import Charts
import SVProgressHUD
import AlamofireImage


class ApprovalCell: UITableViewCell {
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var timeLabel: UILabel!
    @IBOutlet weak var typeLabel: UILabel!
}


class ApprovalVC: UIViewController, UITableViewDataSource, UITableViewDelegate {
    
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var btnBack: UIButton!
    @IBOutlet weak var btnMenu: UIButton!
    @IBOutlet weak var btnType: UIButton!
    @IBOutlet weak var btnNew: UIButton!
    @IBOutlet weak var tableView: UITableView!

    let urls = [[ API_WORKFLOW_01, API_WORKFLOW_02, API_WORKFLOW_03, API_WORKFLOW_04, API_WORKFLOW_05, API_WORKFLOW_06 ],
                [ API_WORKFLOW_11, API_WORKFLOW_12, API_WORKFLOW_13, API_WORKFLOW_14 ]]
    let urls_detail = [ API_WORKFLOW_DETAILS_01, API_WORKFLOW_DETAILS_02, API_WORKFLOW_DETAILS_03, API_WORKFLOW_DETAILS_04, API_WORKFLOW_DETAILS_05 ]

    let ApprovalCellIdentifier = "ApprovalCell"
    
    var memberId: String?
    var flowList = [WorkFlow]()
    var filteredFlowList = [WorkFlow]()
    var currentMenuSection = 0
    var currentMenuIndex = 0
    var currentType = 0
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        if self.memberId == nil || self.memberId?.isEmpty == true {
            self.memberId = User.getUserId()
        }
        
        setupUI()
        
        loadData(0, 0)
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        self.navigationController!.setNavigationBarHidden(true, animated: true)
        self.navigationItem.backBarButtonItem = UIBarButtonItem(title: "", style: .plain, target: nil, action: nil)
        
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func setupUI() {
        
        if self.memberId == nil || self.memberId?.isEmpty == true || self.memberId == User.getUserId() {
            self.titleLabel.text = "我的审批"//NSLocalizedString("setting", comment: "")
        } else {
            self.titleLabel.text = "下属审批"//NSLocalizedString("setting", comment: "")
        }

        btnBack.tap(back)
        btnMenu.tap(showMenu)
        btnType.tap(onSelectType)
        btnNew.tap(newApproval)
        
        tableView.delegate = self
        tableView.dataSource = self

    }
    
    func back() {
        self.viewDeckController?.navigationController?.popViewController(animated: true)
    }
    
    func showMenu() {
        self.viewDeckController?.open(.left, animated: true)
    }
    
    func newApproval() {
        if currentType == 0 {
            let vc = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "AppealDailyVC")
            self.navigationController?.pushViewController(vc, animated: true)
        } else if currentType == 1 {
            let vc = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "AppealAbsenceVC") as! AppealAbsenceVC
            vc.vcType = 0
            self.navigationController?.pushViewController(vc, animated: true)
        } else if currentType == 2 {
            let vc = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "AppealTravelVC")
            self.navigationController?.pushViewController(vc, animated: true)
        } else if currentType == 3 {
            let vc = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "AppealAbsenceVC") as! AppealAbsenceVC
            vc.vcType = 1
            self.navigationController?.pushViewController(vc, animated: true)
        } else if currentType == 4 {
            let vc = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "AppealPunchVC")
            self.navigationController?.pushViewController(vc, animated: true)
        }
    }
    
    func onSelectType() {
        let alert = UIAlertController(title: nil, message: nil, preferredStyle: .actionSheet)
        let firstAction = UIAlertAction(title: "日常申请", style: .default) { (alert: UIAlertAction!) -> Void in
            self.currentType = 0
            self.btnType.setTitle("日常申请", for: .normal)
            self.reloadData()
        }
        
        let secondAction = UIAlertAction(title: "请假申请", style: .default) { (alert: UIAlertAction!) -> Void in
            self.currentType = 1
            self.btnType.setTitle("请假申请", for: .normal)
            self.reloadData()
        }
        
        let thirdAction = UIAlertAction(title: "出差申请", style: .default) { (alert: UIAlertAction!) -> Void in
            self.currentType = 2
            self.btnType.setTitle("出差申请", for: .normal)
            self.reloadData()
        }
        
        let fourthAction = UIAlertAction(title: "加班申请", style: .default) { (alert: UIAlertAction!) -> Void in
            self.currentType = 3
            self.btnType.setTitle("加班申请", for: .normal)
            self.reloadData()
        }
        
        let fifthAction = UIAlertAction(title: "考勤修正申请", style: .default) { (alert: UIAlertAction!) -> Void in
            self.currentType = 4
            self.btnType.setTitle("考勤修正申请", for: .normal)
            self.reloadData()
        }
        
        alert.addAction(firstAction)
        alert.addAction(secondAction)
        alert.addAction(thirdAction)
        alert.addAction(fourthAction)
        alert.addAction(fifthAction)
        present(alert, animated: true, completion:nil)
    }
    
    func reloadData() {
        
        self.filteredFlowList.removeAll()
        for workFlow in self.flowList {
            if Int(workFlow.type) == self.currentType {
                self.filteredFlowList.append(workFlow)
            }
        }
        
        self.tableView.reloadData()
    }

    func loadData(_ section: Int, _ row: Int ) {
        
        SVProgressHUD.show()
        HRMSApi.POST(urls[section][row], params: ["memberID": self.memberId!, "page": 1, "rows": 1000]) { (response: WorkFlowListResponse?, error: HRMSError?) in
            SVProgressHUD.dismiss()
            
            guard response != nil else {
                SVProgressHUD.showError(withStatus: error?.message)
                return
            }
            
            if response?.success == -1 {
                SVProgressHUD.showError(withStatus: "失败.")
                return
            }
            
            self.flowList = (response?.data)!
            
            self.filteredFlowList.removeAll()
            for workFlow in self.flowList {
                if Int(workFlow.type) == self.currentType {
                    self.filteredFlowList.append(workFlow)
                }
            }
            
            self.tableView.reloadData()
        }
    }

    func getDetail(_ type: Int, _ row_id: Int ) {
       
        SVProgressHUD.show()
        HRMSApi.POST(urls_detail[type], params: ["memberID": self.memberId!, "ROW_ID": row_id]) { (response: BaseAppealResponse?, error: HRMSError?) in
            SVProgressHUD.dismiss()
            
            guard response != nil else {
                SVProgressHUD.showError(withStatus: error?.message)
                return
            }
            
            if response?.success == -1 {
                SVProgressHUD.showError(withStatus: "失败.")
                return
            }

            let workflow = response?.workFlow

            var isPostableVC = false
            if self.currentMenuSection == 1 && self.currentMenuIndex == 0 {
                isPostableVC = true
            }

            if workflow?.type == "00" {
                let vc = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "AppealDailyDetailVC") as! AppealDailyDetailVC
                vc.responseData = response
                vc.isPostable = isPostableVC
                self.navigationController?.pushViewController(vc, animated: true)
            } else if workflow?.type == "01" {
                let vc = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "AppealAbsenceDetailVC") as! AppealAbsenceDetailVC
                vc.responseData = response
                vc.isPostable = isPostableVC
                vc.vcType = 0
                self.navigationController?.pushViewController(vc, animated: true)
            } else if workflow?.type == "02" {
                let vc = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "AppealTravelDetailVC") as! AppealTravelDetailVC
                vc.responseData = response
                vc.isPostable = isPostableVC
                self.navigationController?.pushViewController(vc, animated: true)
            } else if workflow?.type == "03" {
                let vc = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "AppealAbsenceDetailVC") as! AppealAbsenceDetailVC
                vc.responseData = response
                vc.isPostable = isPostableVC
                vc.vcType = 1
                self.navigationController?.pushViewController(vc, animated: true)
            } else if workflow?.type == "04" {
                let vc = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "AppealPunchDetailVC") as! AppealPunchDetailVC
                vc.responseData = response
                vc.isPostable = isPostableVC
                self.navigationController?.pushViewController(vc, animated: true)
            }
            
            self.tableView.reloadData()
        }
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return filteredFlowList.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: ApprovalCellIdentifier, for: indexPath as IndexPath) as! ApprovalCell
        
        let workFlow = self.filteredFlowList[indexPath.row]
        cell.titleLabel.text = workFlow.name
        cell.timeLabel.text = workFlow.createdAt
        if workFlow.type == "00" {
            cell.typeLabel.backgroundColor = UIColor.blue
            cell.typeLabel.text = "常"
        } else if workFlow.type == "01" {
            cell.typeLabel.backgroundColor = UIColor.orange
            cell.typeLabel.text = "假"
        } else if workFlow.type == "02" {
            cell.typeLabel.backgroundColor = UIColor.yellow
            cell.typeLabel.text = "差"
        } else if workFlow.type == "03" {
            cell.typeLabel.backgroundColor = UIColor.green
            cell.typeLabel.text = "加"
        } else if workFlow.type == "04" {
            cell.typeLabel.backgroundColor = UIColor.purple
            cell.typeLabel.text = "修"
        }
        
        return cell
    }
    
    // MARK:  UITableViewDelegate Methods
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if !(self.memberId == User.getUserId()) || self.flowList[indexPath.row] == nil {
            return
        }
        
        let workFlow = self.filteredFlowList[indexPath.row]
        self.getDetail(Int(workFlow.type)!, workFlow.rowId)
    }
}

extension ApprovalVC: SideMenuDelegate {
    func onSelectMenu(_ section: Int, _ index: Int) {
        self.viewDeckController?.closeSide(true)
        
        currentMenuSection = section
        currentMenuIndex = index
        self.loadData(section, index)
    }
}
