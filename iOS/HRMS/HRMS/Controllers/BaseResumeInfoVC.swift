//
//  ViewController.swift
//  FZAccordionTableViewExample
//
//  Created by Krisjanis Gaidis on 10/5/15.
//  Copyright © 2015 Fuzz. All rights reserved.
//

import UIKit
import FZAccordionTableView


//
// MARK: - Section Data Structure
//
struct SectionItem {
    var key: String!
    var keyTitle: String!
    var value: String!
    
    init(key: String, keyTitle: String, value: String) {
        self.key = key
        self.keyTitle = keyTitle
        self.value = value
    }
}

struct SectionInfo {
    var name: String!
    var items: [SectionItem]!
    
    init(name: String) {
        self.name = name
    }
    
    init(name: String, items: [SectionItem]) {
        self.name = name
        self.items = items
    }
}

class BaseResumeInfoVC: UIViewController {
    let kTableViewCellReuseIdentifier = "ResumeCell"

    var tableView: FZAccordionTableView = FZAccordionTableView()
    
    var memberId: String?
    var sections = [SectionInfo]()

    override func viewDidLoad() {
        super.viewDidLoad()

        tableView.frame = CGRect(x: 0, y: 220, width: APP_WIDTH, height: APP_HEIGHT - 300)
        tableView.contentInset = UIEdgeInsets(top: 0, left: 0, bottom: 100, right: 0)
        tableView.allowsSelection = false
        tableView.separatorColor = UIColor.clear
        tableView.allowMultipleSectionsOpen = false
        tableView.register(ResumeInfoCell.self, forCellReuseIdentifier: kTableViewCellReuseIdentifier)
        tableView.register(ResumeInfoHeader.self, forHeaderFooterViewReuseIdentifier: ResumeInfoHeader.kResumeInfoHeaderReuseId)

        self.view.backgroundColor = UIColor.clear

        if self.memberId == nil || self.memberId?.isEmpty == true {
            self.memberId = User.getUserId()
        }

        loadInfo()
    }

    func loadInfo() {
        
    }
}

// MARK: - <UITableViewDataSource> / <UITableViewDelegate>

extension BaseResumeInfoVC : UITableViewDelegate, UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return sections[section].items.count
    }
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return sections.count
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return UITableViewAutomaticDimension
    }
    
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return ResumeInfoHeader.kDefaultResumeInfoHeaderHeight
    }
    
    func tableView(_ tableView: UITableView, estimatedHeightForRowAt indexPath: IndexPath) -> CGFloat {
        return self.tableView(tableView, heightForRowAt: indexPath)
    }
    
    func tableView(_ tableView: UITableView, estimatedHeightForHeaderInSection section: Int) -> CGFloat {
        return self.tableView(tableView, heightForHeaderInSection:section)
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: kTableViewCellReuseIdentifier, for: indexPath) as! ResumeInfoCell
        cell.keyLabel.text = sections[indexPath.section].items[indexPath.row].keyTitle
        cell.valueLabel.text = sections[indexPath.section].items[indexPath.row].value
        cell.mainView.layer.borderColor = MAIN_COLORS[indexPath.section % 8].cgColor
        return cell
    }
    
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        let header = tableView.dequeueReusableHeaderFooterView(withIdentifier: ResumeInfoHeader.kResumeInfoHeaderReuseId) as? ResumeInfoHeader ?? ResumeInfoHeader(reuseIdentifier: ResumeInfoHeader.kResumeInfoHeaderReuseId)
        
        header.titleLabel.text = sections[section].name
        header.titleView.backgroundColor = MAIN_COLORS[section]      
        
        return header
    }
}

// MARK: - <FZAccordionTableViewDelegate>
extension BaseResumeInfoVC : FZAccordionTableViewDelegate {

    func tableView(_ tableView: FZAccordionTableView, willOpenSection section: Int, withHeader header: UITableViewHeaderFooterView?) {
        let header = header as! ResumeInfoHeader
        header.btnUpDown.setImage(UIImage(named: "up"), for: .normal)
        header.mainInfoGradientLayer.removeFromSuperlayer()
    }
    
    func tableView(_ tableView: FZAccordionTableView, didOpenSection section: Int, withHeader header: UITableViewHeaderFooterView?) {
        
    }
    
    func tableView(_ tableView: FZAccordionTableView, willCloseSection section: Int, withHeader header: UITableViewHeaderFooterView?) {
        let header = header as! ResumeInfoHeader
        header.mainInfoGradientLayer.removeFromSuperlayer()
        header.btnUpDown.setImage(UIImage(named: "down"), for: .normal)
    }
    
    func tableView(_ tableView: FZAccordionTableView, didCloseSection section: Int, withHeader header: UITableViewHeaderFooterView?) {
        
    }
    
    func tableView(_ tableView: FZAccordionTableView, canInteractWithHeaderAtSection section: Int) -> Bool {
        return true
    }
}
