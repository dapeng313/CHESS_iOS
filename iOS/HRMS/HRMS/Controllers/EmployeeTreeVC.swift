//
//  EmployeeTreeVC.swift
//  HRMS
//
//  Created by Apollo on 1/16/17.
//  Copyright © 2017 Apollo. All rights reserved.
//



import UIKit
import Alamofire
import AlamofireImage
import SVProgressHUD
import Stevia

class EmployeeTreeVC: UIViewController, TreeTableCellDelegate, UICollectionViewDelegate, UICollectionViewDataSource {
    
    @IBOutlet weak var subTitleLabel: UILabel!
    @IBOutlet weak var btnStart: UIButton!
    @IBOutlet weak var treeViewFrame: UIView!
    @IBOutlet weak var groupView: UICollectionView!
    
    var treeView: TreeTableView!

    var employeeData: [OrgUnitItem] = []
    var employeeNodeData: [Node] = []
    var groupData: [String] = []

    let cellReuseIdentifier = "GroupCell"

    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.setupUI()

        self.getChildNodes(-1, -1, User.getUserCoobjid()!, "", "O")
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        self.navigationController!.setNavigationBarHidden(false, animated: true)
        
        self.navigationItem.backBarButtonItem = UIBarButtonItem(title: "", style: .plain, target: nil, action: nil)
        
        self.navigationItem.title = NSLocalizedString("start_chat", comment: "")
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
        btnStart.setTitle(NSLocalizedString("start", comment: ""), for: .normal)
        btnStart.tap(onTapStart)

        treeView = TreeTableView(frame: CGRect(x: CGFloat(0), y: CGFloat(1), width: CGFloat(self.view.frame.width), height: CGFloat(self.treeViewFrame.frame.height - 2)),
                                 withData: employeeNodeData)
        self.treeViewFrame.sv(self.treeView.centerInContainer())
        self.treeView.backgroundColor = UIColor.white
        self.treeView.treeTableCellDelegate = self

        self.groupView.delegate = self
        self.groupView.dataSource = self
        self.groupView.isPagingEnabled = true
        self.groupView.register(GroupCell.self, forCellWithReuseIdentifier: cellReuseIdentifier)
    }

    func onTapStart() {
        if self.groupData.count <= 0 {
            return
        }
        
        var members: [String] = groupData
        members.append(User.getUserId()!)
        let option = NIMCreateTeamOption()
        option.name = "讨论组"
        option.type = NIMTeamType.normal

        SVProgressHUD.show()
        NIMSDK.shared().teamManager.createTeam(option, users: members, completion: {(error: Error?, teamId: String?) -> Void in
            SVProgressHUD.dismiss()

            if error == nil {
                let session: NIMSession = NIMSession(teamId!, type: NIMSessionType.team)
                if let vc = SessionVC(session: session) {
                    self.navigationController?.pushViewController(vc, animated: true)
                }
            } else {
                SVProgressHUD.showError(withStatus: error.debugDescription)
            }
        })

    }

// MARK: - TreeTableCellDelegate

    func cellClick(_ node: Node) {

        let item = node.tag as! OrgUnitItem
        if item.nodeType == "P" {
            if User.getUserId() == item.nodeId {
                return
            }

            if self.groupData.contains(item.nodeId) {
                return
            }

            self.groupData.append(item.nodeId)
            self.groupView.reloadData()
        } else {
            node.isExpanded = !node.isExpanded
            if !node.hasChild {
                self.getChildNodes(Int(node.nodeId), Int(node.depth), "", item.nodeId, item.nodeType)
            }
        }
    }

// MARK: - GroupTableCell

    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return self.groupData.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        
        // create a new cell if needed or reuse an old one
        let cell: GroupCell = self.groupView.dequeueReusableCell(withReuseIdentifier: cellReuseIdentifier, for: indexPath as IndexPath) as! GroupCell
        let strUrl = API_URL+API_PHOTO+groupData[indexPath.row] as String
        let url = URL(string: strUrl)!
        let filter = AspectScaledToFillSizeCircleFilter(size: cell.mainView.frame.size)
        cell.mainView.af_setImage(withURL: url, placeholderImage: UIImage(named: "avatar_user"))//?.af_imageRoundedIntoCircle(), filter: filter)
        cell.mainView.layer.cornerRadius = 20
        cell.mainView.layer.masksToBounds = true

        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        let alertController = UIAlertController(title: "Remove User", message: "Do you want to remove user?", preferredStyle: UIAlertControllerStyle.alert)
        let cancelAction = UIAlertAction(title: "Cancel", style: UIAlertActionStyle.default) {
            (result : UIAlertAction) -> Void in
        }
        
        // Replace UIAlertActionStyle.Default by UIAlertActionStyle.default
        let okAction = UIAlertAction(title: "OK", style: UIAlertActionStyle.default) {
            (result : UIAlertAction) -> Void in
            
            self.groupData.remove(at: indexPath.row)
            self.groupView.reloadData()
        }
        
        alertController.addAction(cancelAction)
        alertController.addAction(okAction)
        self.present(alertController, animated: true, completion: nil)

    }

}
