//
//  SettingsVC.swift
//  HRMS
//
//  Created by Apollo on 1/23/17.
//  Copyright © 2017 Apollo. All rights reserved.
//

import UIKit
import AlamofireImage
import SVProgressHUD

class SettingsVC: UIViewController {

    @IBOutlet weak var avatarView: UIView!
    @IBOutlet weak var phoneView: UIView!
    @IBOutlet weak var notificationView: UIView!
    @IBOutlet weak var languageView: UIView!
    @IBOutlet weak var feedbackView: UIView!
    @IBOutlet weak var aboutView: UIView!

    @IBOutlet weak var avatar: UIImageView!
    @IBOutlet weak var phoneLabel: UILabel!
    @IBOutlet weak var btnLogout: UIButton!
    
    var userId: String?
    override func viewDidLoad() {
        super.viewDidLoad()
        
        userId = User.getUserId()

        setupUI()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        self.navigationController!.setNavigationBarHidden(false, animated: true)
        self.navigationItem.backBarButtonItem = UIBarButtonItem(title: "", style: .plain, target: nil, action: nil)
        
        self.navigationItem.title = "设置"//NSLocalizedString("setting", comment: "")
        self.navigationController?.navigationBar.frame = CGRect(x: 0, y: 0, width: (self.view.frame.width), height: 75)

        updateUI()
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    func updateUI() {
        let strPhone = UserDefaults.standard.string(forKey: "phone")
        if strPhone != nil || !(strPhone?.isEmpty)! {
            self.phoneLabel.text = strPhone
        }
    }

    func setupUI() {

        let strUrl = API_URL+API_PHOTO+self.userId! as String
        let url = URL(string: strUrl)!
        let filter = AspectScaledToFillSizeCircleFilter(size: avatarView.frame.size)
        avatar.af_setImage(withURL: url, placeholderImage: UIImage(named: "avatar_user")?.af_imageRoundedIntoCircle(), filter: filter)

        btnLogout.tap(logout)

        self.avatarView.layer.borderColor = UIColor.groupTableViewBackground.cgColor
        self.phoneView.layer.borderColor = UIColor.groupTableViewBackground.cgColor
        self.notificationView.layer.borderColor = UIColor.groupTableViewBackground.cgColor
        self.languageView.layer.borderColor = UIColor.groupTableViewBackground.cgColor
        self.feedbackView.layer.borderColor = UIColor.groupTableViewBackground.cgColor
        self.aboutView.layer.borderColor = UIColor.groupTableViewBackground.cgColor

        let gesture1 = UITapGestureRecognizer(target: self, action:  #selector (self.avatarAction(_:)))
        self.avatarView.addGestureRecognizer(gesture1)
        
        let gesture2 = UITapGestureRecognizer(target: self, action:  #selector (self.phoneAction(_:)))
        self.phoneView.addGestureRecognizer(gesture2)
        
        let gesture3 = UITapGestureRecognizer(target: self, action:  #selector (self.notificationAction(_:)))
        self.notificationView.addGestureRecognizer(gesture3)
        
        let gesture4 = UITapGestureRecognizer(target: self, action:  #selector (self.languageAction(_:)))
        self.languageView.addGestureRecognizer(gesture4)
       
        let gesture5 = UITapGestureRecognizer(target: self, action:  #selector (self.feedbackAction(_:)))
        self.feedbackView.addGestureRecognizer(gesture5)
        
        let gesture6 = UITapGestureRecognizer(target: self, action:  #selector (self.aboutAction(_:)))
        self.aboutView.addGestureRecognizer(gesture6)

        loadContact()
    }

    func avatarAction(_ sender:UITapGestureRecognizer){
        //let vc = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "LoginVC")
        //self.navigationController?.pushViewController(vc, animated: true)
    }
    
    func phoneAction(_ sender:UITapGestureRecognizer){
        let vc = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "PhoneVC")
        self.navigationController?.pushViewController(vc, animated: true)
    }
    
    func notificationAction(_ sender:UITapGestureRecognizer){
        //let vc = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "NotificationVC")
        //self.navigationController?.pushViewController(vc, animated: true)
    }
    
    func languageAction(_ sender:UITapGestureRecognizer){
        let vc = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "LanguageVC")
        self.navigationController?.pushViewController(vc, animated: true)
    }
    
    func feedbackAction(_ sender:UITapGestureRecognizer){
        let vc = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "FeedbackVC")
        self.navigationController?.pushViewController(vc, animated: true)
    }
    
    func aboutAction(_ sender:UITapGestureRecognizer){
        let vc = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "AboutVC")
        self.navigationController?.pushViewController(vc, animated: true)
    }
    
    func loadContact() {
        
        SVProgressHUD.show()
        HRMSApi.POST(API_PERSON_EVENT_STATUS, params: ["objid": self.userId!]) { (contactInfo: ContactInfoResponse?, error: HRMSError?) in
            SVProgressHUD.dismiss()
            
            guard contactInfo != nil else {
                SVProgressHUD.showError(withStatus: error?.message)
                return
            }

            var phone: String?
            for info in (contactInfo?.data)! {
                if info.cutyp == "02" {
                    phone = info.cunum
                }
            }
            
            self.phoneLabel.text = throwEmpty(phone)
            UserDefaults.standard.set(phone, forKey: "phone")
        }
    }
    
    func logout() {
        NIMSDK.shared().loginManager.logout(nil)

        let vc = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "LoginVC")
        self.navigationController?.pushViewController(vc, animated: true)
    }
    
}
