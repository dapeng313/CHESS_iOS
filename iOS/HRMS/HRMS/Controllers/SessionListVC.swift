//
//  SessionListVC.swift
//  HRMS
//
//  Created by Apollo on 1/9/17.
//  Copyright © 2017 Apollo. All rights reserved.
//


import UIKit
import Stevia

class SessionListVC: NIMSessionListViewController {
    
    var emptyTipLabel = UILabel()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.setupUI()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)

        self.navigationController!.setNavigationBarHidden(false, animated: true)
        
        self.navigationItem.backBarButtonItem = UIBarButtonItem(title: "", style: .plain, target: nil, action: nil)
        self.navigationItem.rightBarButtonItem = UIBarButtonItem(image: UIImage(named: "new_chat"), style: .plain, target: self, action: #selector(self.onBtnContacts))

        self.navigationItem.title = NSLocalizedString("chat", comment: "")
        self.navigationController?.navigationBar.frame = CGRect(x: 0, y: 0, width: (self.view.frame.width), height: 75)
    }
   
    
    override func reload() {
        super.reload()
        
        self.emptyTipLabel.isHidden = self.recentSessions.count != 0
    }
    
    override func onSelectedRecent(_ recent: NIMRecentSession, at indexPath: IndexPath) {
        let vc = SessionVC(session: recent.session)
        self.navigationController!.pushViewController(vc!, animated: true)
    }
    
    override func onDeleteRecent(atIndexPath recent: NIMRecentSession, at indexPath: IndexPath) {
        super.onDeleteRecent(atIndexPath: recent, at: indexPath)
        
        self.emptyTipLabel.isHidden = self.recentSessions.count != 0
    }
    
    func setupUI() {        
       
        self.tableView.frame = CGRect(x: 0, y: 10, width: self.view.bounds.width, height: self.tableView.bounds.height)

        self.emptyTipLabel = UILabel()
        self.emptyTipLabel.text = "还没有会话，在通讯录中找个人聊聊吧"
        self.emptyTipLabel.sizeToFit()
        self.emptyTipLabel.center = self.tableView.center
        self.emptyTipLabel.isHidden = self.recentSessions.count != 0
        self.view.addSubview(self.emptyTipLabel)
    }
    
    func onBtnContacts() {
        let vc = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "EmployeeTreeVC")
        self.navigationController!.pushViewController(vc, animated: true)
    }
}
