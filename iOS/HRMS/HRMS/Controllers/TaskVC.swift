//
//  TaskVC.swift
//  HRMS
//
//  Created by Apollo on 2/2/17.
//  Copyright © 2017 Apollo. All rights reserved.
//


import UIKit
import Charts
import SVProgressHUD
import AlamofireImage
import Alamofire

class TaskCell: UITableViewCell {
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var timeLabel: UILabel!
    @IBOutlet weak var fromAvatarView: UIImageView!
    @IBOutlet weak var fromNameLabel: UILabel!
    @IBOutlet weak var toAvatarView: UIImageView!
    @IBOutlet weak var toNameLabel: UILabel!
}


class TaskVC: UIViewController, UITableViewDataSource, UITableViewDelegate {

    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var btnBack: UIButton!
    @IBOutlet weak var btnMenu: UIButton!
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var btnAdd: UIButton!
    
    let TaskCellIdentifier = "TaskCell"
    
    var memberId: String?
    var taskList = [TaskInfo]()
    var currentSection = 1
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        if self.memberId == nil || self.memberId?.isEmpty == true {
            self.memberId = User.getUserId()
        }
        
        setupUI()
        
        loadData("", self.memberId!, "01")
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
            self.titleLabel.text = "我的任务"//NSLocalizedString("setting", comment: "")
        } else {
            self.titleLabel.text = "下属任务"//NSLocalizedString("setting", comment: "")
        }

        btnBack.tap(back)
        btnMenu.tap(showMenu)
        btnAdd.tap(newTask)
        
        tableView.delegate = self
        tableView.dataSource = self

    }

    func back() {
        self.viewDeckController?.navigationController?.popViewController(animated: true)
    }

    func showMenu() {
        self.viewDeckController?.open(.left, animated: true)
    }
    
    func newTask() {
        let vc = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "NewTaskVC")
        self.navigationController?.pushViewController(vc, animated: true)
    }
   
    func loadData(_ fromMember: String?, _ excuteMember: String?, _ excuteState: String? ) {
        
        var params = ["page": 1, "rows": 1000] as Parameters

        if fromMember != nil && fromMember?.isEmpty == false {
            params["FROM_MEMBER"] = fromMember
        }
        
        if excuteMember != nil && excuteMember?.isEmpty == false {
            params["EXCUTE_MEMBER"] = excuteMember
        }
        
        if excuteState != nil && excuteState?.isEmpty == false {
            params["EXCUTE_STATE"] = excuteState
        }

        SVProgressHUD.show()
        HRMSApi.POST(API_TASK_LIST, params: params) { (response: TaskInfoResponse?, error: HRMSError?) in
            SVProgressHUD.dismiss()
            
            guard response != nil else {
                SVProgressHUD.showError(withStatus: error?.message)
                return
            }
            
            if response?.success == -1 {
                SVProgressHUD.showError(withStatus: "失败.")
                return
            }
            
            if response?.taskList == nil {
                return
            }

            self.taskList = (response?.taskList)!
            
            self.tableView.reloadData()
        }
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return taskList.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: TaskCellIdentifier, for: indexPath as IndexPath) as! TaskCell
        
        let row = indexPath.row
        cell.titleLabel.text = self.taskList[row].taskTheme
        cell.timeLabel.text = self.taskList[row].taskStartDate
        cell.fromNameLabel.text = self.taskList[row].fromName
        cell.toNameLabel.text = self.taskList[row].excuteName
        
        var strUrl = API_URL+API_PHOTO+(self.taskList[row].fromMember) as String
        var url = URL(string: strUrl)!
        let filter = AspectScaledToFillSizeCircleFilter(size: cell.fromAvatarView.frame.size)
        cell.fromAvatarView.af_setImage(withURL: url, placeholderImage: UIImage(named: "avatar_user")?.af_imageRoundedIntoCircle(), filter: filter)
        
        strUrl = API_URL+API_PHOTO+(self.taskList[row].excuteMember) as String
        url = URL(string: strUrl)!
        cell.toAvatarView.af_setImage(withURL: url, placeholderImage: UIImage(named: "avatar_user")?.af_imageRoundedIntoCircle(), filter: filter)

        return cell
    }
    
    // MARK:  UITableViewDelegate Methods
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if !(self.memberId == User.getUserId()) || self.taskList[indexPath.row] == nil{
            return
        }

        let vc = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "TaskDetailVC") as! TaskDetailVC
        vc.taskInfo = self.taskList[indexPath.row]
        vc.viewMode = currentSection
        self.navigationController?.pushViewController(vc, animated: true)
    }
}

extension TaskVC: SideMenuDelegate {
    func onSelectMenu(_ section: Int, _ index: Int) {
        self.viewDeckController?.closeSide(true)

        currentSection = section + 1
        let strStatus = String(format: "%02d", index+1)
        if section == 0 {
            self.loadData("", self.memberId, strStatus)
        } else {
            self.loadData(self.memberId, "", strStatus)
        }
    }
}
