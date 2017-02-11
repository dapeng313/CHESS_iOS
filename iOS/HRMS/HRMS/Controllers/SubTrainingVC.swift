//
//  SubCourseVC.swift
//  HRMS
//
//  Created by Apollo on 1/31/17.
//  Copyright © 2017 Apollo. All rights reserved.
//

import UIKit
import Charts
import SVProgressHUD
import AlamofireImage

import UIKit
import Charts
import SVProgressHUD
import AlamofireImage

class SubTrainingCell: UITableViewCell {
    @IBOutlet weak var avatarView: UIImageView!
    @IBOutlet weak var nameLabel: UILabel!
}


class SubTrainingVC: UIViewController, UITableViewDataSource, UITableViewDelegate {
    
    @IBOutlet weak var webView: UIWebView!
    @IBOutlet weak var tableView: UITableView!
    
    let SubTrainingCellIdentifier = "SubTrainingCell"
    
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
        
        self.navigationItem.title = "下属培训"//NSLocalizedString("setting", comment: "")
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
        let url: String = HRMSApi.getURL(API_TRAINING_WEBVIEW)+User.getUserId()!
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
        let cell = tableView.dequeueReusableCell(withIdentifier: SubTrainingCellIdentifier, for: indexPath as IndexPath) as! SubTrainingCell
        
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
        let vc = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "TrainingVC") as! TrainingVC
        vc.memberId = self.members[indexPath.row].id
        self.navigationController?.pushViewController(vc, animated: true)
    }
}

/*
class SubTrainingVC: BasePieChartVC {    
   
    var titles: [String]?
    var values = [Double]()
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        self.navigationItem.title = "下属培训"//NSLocalizedString("setting", comment: "")
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    override func loadData() {
        
        let year = Calendar.current.component(.year, from: Date())
        
        let begda = String(year)+"-01-01"
        let endda = String(year)+"-12-31"

        SVProgressHUD.show()
        HRMSApi.POST(API_SURBO_EVENT_LIST, params: ["memberID": User.getUserId()!, "BEGDA": begda, "ENDDA": endda]) { (response: CourseInfoResponse?, error: HRMSError?) in
            SVProgressHUD.dismiss()
            
            guard response != nil else {
                SVProgressHUD.showError(withStatus: error?.message)
                return
            }
            
            if response?.success == -1 {
                SVProgressHUD.showError(withStatus: "失败.")
                return
            }

            if response?.data == nil || (response?.data?.count)! <= 0 {
                SVProgressHUD.showError(withStatus: "数据空!")
                return
            }
//            for courseInfo in (response?.data)! {
//                let id = courseInfo.pernr
//            }
           
            self.setChart(self.titles!, values: self.values)

        }
    }
    
    // MARK:  UITableViewDelegate Methods
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
//        let vc = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "TrainingVC") as! TrainingVC
//        vc.memberId = self.members[indexPath.row].id
//        self.navigationController?.pushViewController(vc, animated: true)
    }
}
 */
