//
//  BaseInputVC.swift
//  HRMS
//
//  Created by Apollo on 2/1/17.
//  Copyright © 2017 Apollo. All rights reserved.
//

import UIKit

class BaseInputVC: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.view.addGlobalKeyboardObserver()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        self.navigationController!.setNavigationBarHidden(false, animated: true)

        self.navigationItem.backBarButtonItem = UIBarButtonItem(title: "", style: .plain, target: nil, action: nil)
        self.navigationItem.hidesBackButton = true
        self.navigationItem.leftBarButtonItem = UIBarButtonItem(image: UIImage(named: "back"), style: .plain, target: self, action: #selector(self.back(sender:)))
        
        self.navigationController?.navigationBar.frame = CGRect(x: 0, y: 0, width: (self.view.frame.width), height: 75)
    }

    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)

        self.view.removeGlobalKeyboardObserver()
    }

    func back(sender: UIBarButtonItem) {
        self.view.endEditing(true)

        // Go back to the previous ViewController
        _ = navigationController?.popViewController(animated: true)
    }
}
