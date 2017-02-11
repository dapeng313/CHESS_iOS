//
//  PhoneVC.swift
//  HRMS
//
//  Created by Apollo on 1/31/17.
//  Copyright © 2017 Apollo. All rights reserved.
//

import UIKit
import SVProgressHUD
import Alamofire

class PhoneVC: UIViewController {

    @IBOutlet weak var phoneField: UITextField!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setupUI()
        
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        self.navigationController!.setNavigationBarHidden(false, animated: true)
        self.navigationItem.backBarButtonItem = UIBarButtonItem(title: "", style: .plain, target: nil, action: nil)
        self.navigationItem.rightBarButtonItem = UIBarButtonItem(title: "保存", style: .plain, target: self, action: #selector(save))
        
        self.navigationItem.title = "手机"//NSLocalizedString("setting", comment: "")
        self.navigationController?.navigationBar.frame = CGRect(x: 0, y: 0, width: (self.view.frame.width), height: 75)
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        self.view.endEditing(true)
    }

    func setupUI() {
        self.phoneField.layer.borderColor = UIColor.groupTableViewBackground.cgColor
        self.phoneField.leftViewMode = .always
        let leftLabel = UILabel(frame: CGRect(x: 0, y: 0, width: 80, height: phoneField.frame.size.height))
        leftLabel.font = .systemFont(ofSize: 14)
        leftLabel.textAlignment = .center
        leftLabel.textColor = Colors.textColor
        leftLabel.text = "手机 :"
        self.phoneField.leftView = leftLabel

        phoneField.text = UserDefaults.standard.string(forKey: "phone")
    }

    func save() {
        let strPhoneNum = phoneField.text
        if strPhoneNum == nil || strPhoneNum?.isEmpty == true {
            
            let alertController = UIAlertController(title: "错误", message: "手机号码不能为空!", preferredStyle: UIAlertControllerStyle.alert)
            let okAction = UIAlertAction(title: "确认", style: UIAlertActionStyle.default) {
                (result : UIAlertAction) -> Void in
            }
            
            alertController.addAction(okAction)
            self.present(alertController, animated: true, completion: nil)
        } else {
            
            let params : Parameters? = ["PERNR": User.getUserId()!, "CUTYP": "02", "CUNUM": strPhoneNum!, "FLOW_ID": "1"]
            
            SVProgressHUD.show()
            HRMSApi.POST(API_SAVE_PHONE_NUMBER, params: params) { (response: HRMSResponse?, error: HRMSError?) in
                SVProgressHUD.dismiss()
                
                guard response != nil else {
                    SVProgressHUD.showError(withStatus: error?.message)
                    return
                }
                
                if response?.success == -1 {
                    SVProgressHUD.showError(withStatus: "失败.")
                    return
                }

                UserDefaults.standard.set(strPhoneNum!, forKey: "phone")
            }
        }
    }
}
