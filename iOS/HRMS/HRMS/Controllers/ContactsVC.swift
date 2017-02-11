//
//  ContactsVC.swift
//  HRMS
//
//  Created by Apollo on 1/30/17.
//  Copyright © 2017 Apollo. All rights reserved.
//


import UIKit
import Alamofire
import AlamofireImage
import SVProgressHUD
import Stevia

protocol ContactsVCDelegate {
    func onSelectContact(_ vc:ContactsVC, _ itemId: String, _ itemName: String)
}

class ContactsVC: UIViewController, TreeTableCellDelegate {
    
    var treeView: TreeTableView!
    
    var employeeData: [OrgUnitItem] = []
    var employeeNodeData: [Node] = []

    var delegate: ContactsVCDelegate?

    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.setupUI()
        
        self.getChildNodes(-1, -1, User.getUserCoobjid()!, "", "O")
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        self.navigationController!.setNavigationBarHidden(false, animated: true)
        
        self.navigationItem.backBarButtonItem = UIBarButtonItem(title: "", style: .plain, target: nil, action: nil)
        
        self.navigationItem.title = "选择审批人"//NSLocalizedString("start_chat", comment: "")
        self.navigationController?.navigationBar.frame = CGRect(x: 0, y: 0, width: (self.view.frame.width), height: 75)
    }
    
    func getChildNodes(_ parentId: Int, _ parentDepth: Int, _ cobjid: String, _ objid: String, _ otype: String) {
        let params : Parameters?
        
        if cobjid.isEmpty {
            params = ["SOBID": objid, "OTYPE": otype, "COOBJID": User.getUserCoobjid()!]
        } else {
            params = ["OBJID": cobjid, "OTYPE": otype, "COOBJID": User.getUserCoobjid()!]
        }
        
        SVProgressHUD.show()
        
        HRMSApi.POST(API_ORG_UNIT_TREE, params: params) { (orgUnitItems: [OrgUnitItem]?, error: HRMSError?) in
            SVProgressHUD.dismiss()
            
            guard orgUnitItems != nil else {
                SVProgressHUD.showError(withStatus: error?.message)
                
                return
            }
            
            if (orgUnitItems?.count)! <= 0 {
//                SVProgressHUD.showError(withStatus: "Data is empty")
                return
            }
            
            //set hasChild
            if parentId >= 0 {
                let item = self.employeeNodeData[parentId] as Node
                item.hasChild = true
                self.employeeNodeData[parentId] = item
            }
            
            //add Children
            for var i in 0..<(orgUnitItems?.count)! {
                let item = (orgUnitItems?[i])! as OrgUnitItem
                let node = Node(parentId: Int32(parentId), nodeId: Int32(i), name: item.nodeName, depth: parentDepth + 1, expand: true, tag: item)
                node?.hasChild = false
                node?.isExpanded = false
                node?.isLeaf = item.nodeType == "P"
                
                if parentId < 0 || parentId == self.employeeData.count-i-1 {
                    self.employeeData.append(item)
                    self.employeeNodeData.append(node!)
                } else {
                    self.employeeData.insert(item, at: parentId + i + 1)
                    self.employeeNodeData.insert(node!, at: parentId + i + 1)
                }
            }
            
            for var i in 0..<self.employeeNodeData.count {
                let item = self.employeeNodeData[i] as Node
                item.nodeId = Int32(i)
                self.employeeNodeData[i] = item
            }
            
            self.treeView.setData(self.employeeNodeData)
            self.treeView.reloadData()
        }
    }
    
    func setupUI() {
        
        treeView = TreeTableView(frame: CGRect(x: CGFloat(0), y: CGFloat(1), width: CGFloat(self.view.frame.width), height: CGFloat(self.view.frame.height - 2)),
                                 withData: employeeNodeData)
        self.view.sv(self.treeView.centerInContainer())
        self.treeView.backgroundColor = UIColor.white
        self.treeView.treeTableCellDelegate = self
    }
    
    // MARK: - TreeTableCellDelegate
    
    func cellClick(_ node: Node) {
        
        let item = node.tag as! OrgUnitItem
        if item.nodeType == "P" {
            if User.getUserId() == item.nodeId {
                return
            }

            delegate?.onSelectContact(self, item.nodeId, item.nodeName)
        } else {
            node.isExpanded = !node.isExpanded
            if !node.hasChild {
                self.getChildNodes(Int(node.nodeId), Int(node.depth), "", item.nodeId, item.nodeType)
            }
        }
    }
}
