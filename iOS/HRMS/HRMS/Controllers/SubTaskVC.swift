//
//  SubTaskVC.swift
//  HRMS
//
//  Created by Apollo on 1/31/17.
//  Copyright © 2017 Apollo. All rights reserved.
//

import UIKit
import SVProgressHUD
import AlamofireImage

class SubTaskCell: UITableViewCell {
    @IBOutlet weak var avatarView: UIImageView!
    @IBOutlet weak var nameLabel: UILabel!
}


class SubTaskVC: UIViewController, UITableViewDataSource, UITableViewDelegate {
    
    @IBOutlet weak var webView: UIWebView!
    @IBOutlet weak var tableView: UITableView!
    
    let SubTaskCellIdentifier = "SubTaskCell"
    
    var months: [String]?
    var monthTotal = [Double]()
    
    var members = [Member]()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setupUI()
        
        loadData()

        loadMemberList()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        self.navigationController!.setNavigationBarHidden(false, animated: true)
        self.navigationItem.backBarButtonItem = UIBarButtonItem(title: "", style: .plain, target: nil, action: nil)
        
        self.navigationItem.title = "下属任务"//NSLocalizedString("setting", comment: "")
        self.navigationController?.navigationBar.frame = CGRect(x: 0, y: 0, width: (self.view.frame.width), height: 75)
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func setupUI() {
        
        tableView.delegate = self
        tableView.dataSource = self
    }
    
    func loadData() {
        let url: String = HRMSApi.getURL(API_TASK_WEBVIEW)+User.getUserId()!
        webView.loadRequest(URLRequest(url: URL(string: url)!))
    }
   
    func loadMemberList() {
        
        SVProgressHUD.show()
        HRMSApi.POST(API_SUBORDINATES_LIST, params: ["memberID": User.getUserId()!]) { (response: SubordinateInfoResponse?, error: HRMSError?) in
            SVProgressHUD.dismiss()
            
            guard response != nil else {
                SVProgressHUD.showError(withStatus: error?.message)
                return
            }
            
            if response?.success == -1 {
                SVProgressHUD.showError(withStatus: "失败.")
                return
            }
            
            for companyInfo in (response?.data)! {
                for memberInfo in (companyInfo.children)! {
                    self.members.append(Member(id: memberInfo.pernr, name: memberInfo.nachn, orgname: companyInfo.name, plansname: memberInfo.plansname, email: memberInfo.email))
                }
            }
            
            self.tableView.reloadData()
        }
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return members.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: SubTaskCellIdentifier, for: indexPath as IndexPath) as! SubTaskCell
        
        let row = indexPath.row
        cell.nameLabel.text = self.members[row].name
        
        let strUrl = API_URL+API_PHOTO+self.members[row].id as String
        let url = URL(string: strUrl)!
        let filter = AspectScaledToFillSizeCircleFilter(size: cell.avatarView.frame.size)
        cell.avatarView.af_setImage(withURL: url, placeholderImage: UIImage(named: "avatar_user")?.af_imageRoundedIntoCircle(), filter: filter)
        
        return cell
    }
    
    // MARK:  UITableViewDelegate Methods
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let menuVC = TaskMenuVC()
        let mainVC = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "TaskVC") as! TaskVC
        mainVC.memberId = self.members[indexPath.row].id
        menuVC.delegate = mainVC
        let vc = SideMenuContainerVC(center: mainVC, leftViewController: menuVC)
        self.navigationController?.pushViewController(vc, animated: true)
    }
}
