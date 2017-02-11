//
//  SideMenuContainerVC.swift
//  HRMS
//
//  Created by Apollo on 2/3/17.
//  Copyright © 2017 Apollo. All rights reserved.
//

import UIKit
import ViewDeck

class SideMenuContainerVC: IIViewDeckController {

    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }    
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        self.navigationController!.setNavigationBarHidden(true, animated: true)
        self.navigationItem.backBarButtonItem = UIBarButtonItem(title: "", style: .plain, target: nil, action: nil)
    }

}
