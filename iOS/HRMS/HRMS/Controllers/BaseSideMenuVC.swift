//
//  BaseSideMenuVC.swift
//  HRMS
//
//  Created by Apollo on 2/2/17.
//  Copyright © 2017 Apollo. All rights reserved.
//

import UIKit

protocol SideMenuDelegate {
    func onSelectMenu(_ section: Int, _ index: Int)
}

class BaseSlideMenuVC: UITableViewController {
    
    var headers = [String]()
    var titles1 = [String]()
    var titles2 = [String]()
    var icons1 = [UIImage]()
    var icons2 = [UIImage]()

    var delegate: SideMenuDelegate?

    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.preferredContentSize = CGSize(width: APP_WIDTH*0.7, height: APP_HEIGHT*0.8)

        self.tableView.contentInset = UIEdgeInsets(top: 30, left: 0, bottom: 0, right: 0)
        self.tableView.register(SlideMenuCell.self, forCellReuseIdentifier: "SideMenuCell")
    }

    // MARK: - Table view data source
    override func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat
    {
        return 50.0
    }
    
    override func numberOfSections(in tableView: UITableView) -> Int {
        return 2
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if section == 0 {
            return titles1.count
        } else {
            return titles2.count
        }
   }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "SideMenuCell", for: indexPath) as! SlideMenuCell
        if indexPath.section == 0 {
            cell.iconView.image = icons1[indexPath.row]
            cell.titleLabel.text = titles1[indexPath.row]
        } else {
            cell.iconView.image = icons2[indexPath.row]
            cell.titleLabel.text = titles2[indexPath.row]
        }
        
        return cell
    }
    
    override func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        return headers[section]
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        delegate?.onSelectMenu(indexPath.section, indexPath.row)
    }
}
