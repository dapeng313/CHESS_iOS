//
//  LoginVC.swift
//  HRMS
//
//  Created by Apollo on 1/5/17.
//  Copyright © 2017 Apollo. All rights reserved.
//


import UIKit
import SVProgressHUD

class LoginVC: UIViewController{
    
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var txtUsername: UITextField!
    @IBOutlet weak var txtPasswd: UITextField!
    @IBOutlet weak var btnLogin: UIButton!

    override func viewDidLoad() {
        super.viewDidLoad()

        setupUI()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        self.navigationController!.setNavigationBarHidden(true, animated: true)
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        self.view.endEditing(true)
    }

    func setupUI() {
        titleLabel.text = NSLocalizedString("register", comment: "")

        txtUsername.layer.borderColor = UIColor.lightGray.cgColor
        txtPasswd.layer.borderColor = UIColor.lightGray.cgColor

        btnLogin.setTitle(NSLocalizedString("login", comment: ""), for: .normal)
        btnLogin.tap(self.login)
    }
    
    func login() {
        let username: String = txtUsername.text!.trimmingCharacters(in: CharacterSet.whitespacesAndNewlines)
        let password: String = txtPasswd.text!

        if username.isEmpty || password.isEmpty {
            return
        }
        
        SVProgressHUD.show()
        HRMSApi.POST(API_LOGIN, params: ["MEMBERID": username, "PASSWORD": password]) { (user: User?, error: HRMSError?) in
            SVProgressHUD.dismiss()

            guard user != nil else {
                SVProgressHUD.showError(withStatus: error?.message)

                self.txtPasswd.text = ""
                return
            }
            
            if user?.success == -1 {
                SVProgressHUD.showError(withStatus: "失败.")
                
                self.txtPasswd.text = ""
                return
            }

            user?.saveUser()

            self.loginChat((user?.id)!, (user?.token)!)
            
            for titleKey in Menu.menuMainTitleKeys {
                let index = Menu.menuMainTitleKeys.index(of: titleKey)
                if Menu.menuMainTypes[index!] != 1 {
                    UserDefaults.standard.set(true, forKey: titleKey)
                } else {
                    UserDefaults.standard.set(false, forKey: titleKey)
                }
            }
            
        }
    }
   
    func loginChat(_ id: String?, _ token: String?) {
        SVProgressHUD.show()

        NIMSDK.shared().loginManager.login(id!, token: token!, completion: {(_ error: Error?) -> Void in
            SVProgressHUD.dismiss()
            if error == nil {
                let vc = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "HomeVC")
                self.navigationController?.pushViewController(vc, animated: true)
            } else {
                SVProgressHUD.showError(withStatus: error.debugDescription)
            }
        })
    }
}
