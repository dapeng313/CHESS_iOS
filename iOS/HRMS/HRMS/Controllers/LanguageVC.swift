//
//  LanguageVC.swift
//  HRMS
//
//  Created by Apollo on 1/31/17.
//  Copyright © 2017 Apollo. All rights reserved.
//

import UIKit

class LanguageVC: UIViewController {

    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setupUI()
        
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        self.navigationController!.setNavigationBarHidden(false, animated: true)
        self.navigationItem.backBarButtonItem = UIBarButtonItem(title: "", style: .plain, target: nil, action: nil)
        
        self.navigationItem.title = "语言选择"//NSLocalizedString("setting", comment: "")
        self.navigationController?.navigationBar.frame = CGRect(x: 0, y: 0, width: (self.view.frame.width), height: 75)
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func setupUI() {
        
    }

}
