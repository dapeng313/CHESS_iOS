//
//  TrainingVC.swift
//  HRMS
//
//  Created by Apollo on 2/6/17.
//  Copyright © 2017 Apollo. All rights reserved.
//

import UIKit
import Charts
import SVProgressHUD


class TrainingVC: UIViewController, ScrollPagerDelegate, UITableViewDataSource, UITableViewDelegate {

    @IBOutlet weak var scrollPager: ScrollPager!
    @IBOutlet weak var scrollView: UIScrollView!
    @IBOutlet weak var btnSearch: UIButton!

    var tableView0 = UITableView()
    var tableView1 = UITableView()
    
    let TrainingCellIdentifier = "TrainingCell"

    var memberId: String?
    var courses = [CourseInfo]()
    var courseStates = [CourseStatusInfo]()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        if self.memberId == nil || self.memberId?.isEmpty == true {
            self.memberId = User.getUserId()
        }
      
        setupUI()

        loadData()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        self.navigationController!.setNavigationBarHidden(false, animated: true)
        self.navigationItem.backBarButtonItem = UIBarButtonItem(title: "", style: .plain, target: nil, action: nil)
        
        if self.memberId == nil || self.memberId?.isEmpty == true || self.memberId == User.getUserId(){
            self.navigationItem.title = "我的培训"//NSLocalizedString("setting", comment: "")
        } else {
            self.navigationItem.title = "下属培训"//NSLocalizedString("setting", comment: "")
        }

        self.navigationController?.navigationBar.frame = CGRect(x: 0, y: 0, width: (self.view.frame.width), height: 75)
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func setupUI() {
        self.view.backgroundColor = UIColor.groupTableViewBackground

        btnSearch.layer.borderColor = Colors.primary.cgColor
        btnSearch.tap(loadData)
        
        tableView0.register(BaseMemberCell.self, forCellReuseIdentifier: TrainingCellIdentifier)
        tableView0.frame = CGRect(x: 0, y: 0, width: scrollView.frame.size.width, height: scrollView.frame.size.height-10)
        
        tableView1.register(BaseMemberCell.self, forCellReuseIdentifier: TrainingCellIdentifier)
        tableView1.frame = CGRect(x: 0, y: 0, width: scrollView.frame.size.width, height: scrollView.frame.size.height-10)

        
        scrollPager.delegate = self
        scrollPager.addSegmentsWithTitlesAndViews(segments: [
            ("我的培训", tableView0),
            ("培训报名", tableView1)])
        
    }
    
    func loadData() {
        loadCourseStatusList()
        loadCourseList()
    }
    
    func loadCourseStatusList() {
        
        SVProgressHUD.show()
        HRMSApi.POST(API_PERSON_EVENT_LIST, params: ["objid": self.memberId!, "type": "PA1011", "page": 1, "rows": 100 ]) { (response: CourseStatusInfoResponse?, error: HRMSError?) in
            SVProgressHUD.dismiss()
            
            guard response != nil else {
                SVProgressHUD.showError(withStatus: error?.message)
                return
            }
            
            if response?.success == -1 {
                SVProgressHUD.showError(withStatus: "失败.")
                return
            }
            
            self.courseStates.removeAll()
            for courseInfo in (response?.data)! {
                self.courseStates.append(courseInfo)
            }
            
            self.tableView0.reloadData()
        }
    }
    
    func loadCourseList() {
        
        let year = Calendar.current.component(.year, from: Date())
        
        let begda = String(year)+"-01-01"
        let endda = String(year)+"-12-31"

        SVProgressHUD.show()
        HRMSApi.POST(API_PERSON_EVENT_LIST, params: ["PERNR": self.memberId!, "BEGDA": begda, "ENDDA": endda, "COOBJID": User.getUserCoobjid()! ]) { (response: CourseInfoResponse?, error: HRMSError?) in
            SVProgressHUD.dismiss()
            
            guard response != nil else {
                SVProgressHUD.showError(withStatus: error?.message)
                return
            }
            
            if response?.success == -1 {
                SVProgressHUD.showError(withStatus: "失败.")
                return
            }
            
            self.courses.removeAll()
            for courseInfo in (response?.courseList)! {
                self.courses.append(courseInfo)
            }
            
            self.tableView0.reloadData()
        }
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 80
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if tableView == tableView0 {
            return courseStates.count
        } else {
            return courses.count
        }
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: TrainingCellIdentifier, for: indexPath as IndexPath) as! TrainingCell
        
        let row = indexPath.row
        if tableView == tableView0 {
            let courseInfo = self.courseStates[row]
            if courseInfo.trype == "01" {
                cell.typeIcon.image = UIImage(named: "training_in")!
                cell.typeLabel.text = "内部培训"
            } else {
                cell.typeIcon.image = UIImage(named: "training_out")!
                cell.typeLabel.text = "外部培训"
            }
            cell.nameLabel.text = courseInfo.couna
            cell.dateLabel.text = courseInfo.begda+"－"+courseInfo.endda
            cell.stateLabel.text = courseInfo.trrst
        } else {
            let courseInfo = self.courses[row]
            if courseInfo.trype == "01" {
                cell.typeIcon.image = UIImage(named: "training_in")!
                cell.typeLabel.text = "内部培训"
            } else {
                cell.typeIcon.image = UIImage(named: "training_out")!
                cell.typeLabel.text = "外部培训"
            }
            cell.nameLabel.text = courseInfo.couna
            cell.dateLabel.text = courseInfo.begda+"－"+courseInfo.endda
            if courseInfo.coust == "02" {
                cell.stateLabel.text = "已报名"
            } else if courseInfo.coust == "03" {
                cell.stateLabel.text = "已取消"
            }
        }
        
        return cell
    }
    
    // MARK:  UITableViewDelegate Methods
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if tableView == tableView0 {
            let vc = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "TrainingDetailVC") as! TrainingDetailVC
            vc.info = self.courseStates[indexPath.row]
            self.navigationController?.pushViewController(vc, animated: true)
        } else {
            let vc = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "CourseDetailVC") as! CourseDetailVC
            vc.courseInfo = self.courses[indexPath.row]
            self.navigationController?.pushViewController(vc, animated: true)
        }
    }
}
