//
//  HomeVC.swift
//  HRMS
//
//  Created by Apollo on 1/3/17.
//  Copyright © 2017 Apollo. All rights reserved.
//

import UIKit
import Stevia
import SVProgressHUD
import ImageSlideshow

class HomeVC: UIViewController, UICollectionViewDelegate, UICollectionViewDataSource{

    @IBOutlet weak var imageSlideView: ImageSlideshow!
    @IBOutlet weak var btnChat: UIButton!
    @IBOutlet weak var btnAttendance: UIButton!
    @IBOutlet weak var btnSettings: UIButton!
    @IBOutlet weak var mainView: UIView!
    @IBOutlet weak var unreadMark: UIView!

    var mainMenuView: UICollectionView!

    var menuItems: [MenuItem] = []

    var unreadCellCount = 0
    var unreadChatViewHeight : CGFloat = 0.0
    var taskViewHeight : CGFloat = 0.0

    var unreadSessions = [NIMRecentSession]()
    var taskList = [TaskInfo]()
    
    var isManagerAccount = true
    
    fileprivate lazy var dateFormat: DateFormatter = {
        let formatter = DateFormatter()
        formatter.dateFormat = "yyyy-MM-dd"
        return formatter
    }()

    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.setupView()

        self.loadUnreadSessions()
        self.loadTask()
        self.loadMenu()

        
        self.refreshContents()
    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)

        self.navigationController!.setNavigationBarHidden(true, animated: true)
        self.navigationItem.backBarButtonItem = UIBarButtonItem(title: "", style: .plain, target: nil, action: nil)
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func loadUnreadSessions(){
        /* load session */
        let recentSessions = NIMSDK.shared().conversationManager.allRecentSessions()
        if recentSessions == nil {
            return
        }

        for session in recentSessions! {
            if session.unreadCount > 0 {
                self.unreadSessions.append(session)
            }
        }
    }
    
    func loadMenu(){
        /* load Menus */

        for titleKey in Menu.menuMainTitleKeys {
            var isMainMenu = UserDefaults.standard.bool(forKey: titleKey)
            let index = Menu.menuMainTitleKeys.index(of: titleKey)
            if index! == 14 {
                isMainMenu = true
            }

            if !isManagerAccount && (index! < 14 && index! > 7) {
                continue
            }

            if isMainMenu {
                let menuItem = MenuItem(Menu.menuMainTypes[index!], titleKey, Menu.menuMainIcons[index!], isMainMenu)
                menuItems.append(menuItem)
            }
        }
    }
    
    func loadTask() {
        
        SVProgressHUD.show()
        HRMSApi.POST(API_TASK_LIST, params: ["page": 1, "rows": 1000, "EXCUTE_STATE": "02", "EXCUTE_MEMBER": User.getUserId()!]) { (response: TaskInfoResponse?, error: HRMSError?) in
            SVProgressHUD.dismiss()
            
            guard response != nil else {
                SVProgressHUD.showError(withStatus: error?.message)
                return
            }
            
            if response?.success == -1 {
                SVProgressHUD.showError(withStatus: "失败.")
                return
            }
            
            if response?.taskList == nil {
                return
            }

            self.taskList = (response?.taskList)!

            self.refreshContents()
        }
    }

    func refreshContents() {
        self.calculateHeights()
        
        for view in self.mainView.subviews{
            view.removeFromSuperview()
        }
       
        var layouts = [AnyObject]()
        layouts += self.addUnreadChats()
        layouts += self.addTask()
        layouts += self.addMenuView()
        
        self.mainView.layout(layouts)

        if self.mainMenuView != nil {
            self.mainMenuView.reloadData()
        }

        self.unreadMark.isHidden = self.unreadSessions.count <= 0
    }

    func calculateHeights(){
        
        if self.taskList.count > 0 {
            taskViewHeight = 70.0;

            if self.menuItems.count > 3 {
                if self.unreadSessions.count > 0 {
                    unreadChatViewHeight = 70.0
                    unreadCellCount = 1
                } else {
                    unreadChatViewHeight = 0.0
                    unreadCellCount = 0
                }
            } else {
                if self.unreadSessions.count > 2 {
                    unreadChatViewHeight = CGFloat(2 * 70.0)
                    unreadCellCount = 2
                } else {
                    unreadChatViewHeight = CGFloat(Double(unreadSessions.count * 70))
                    unreadCellCount = unreadSessions.count
                }
            }
        } else {
            taskViewHeight = 0.0;
            
            if self.menuItems.count > 3 {
                if self.unreadSessions.count > 2 {
                    unreadChatViewHeight = CGFloat(2 * 70.0)
                    unreadCellCount = 2
                } else {
                    unreadChatViewHeight = CGFloat(Double(unreadSessions.count * 70))
                    unreadCellCount = unreadSessions.count
                }
            } else {
                if self.unreadSessions.count > 3 {
                    unreadChatViewHeight = CGFloat(3 * 70.0)
                    unreadCellCount = 3
                } else {
                    unreadChatViewHeight = CGFloat(Double(unreadSessions.count * 70))
                    unreadCellCount = unreadSessions.count
                }
            }
        }
    }

    func setupView(){
        btnChat.setTitle(NSLocalizedString("chat", comment: ""), for: .normal)
        btnAttendance.setTitle(NSLocalizedString("attendance", comment: ""), for: .normal)
        btnSettings.setTitle(NSLocalizedString("settings", comment: ""), for: .normal)

        self.unreadMark.layer.cornerRadius = 3.5
        self.unreadMark.isHidden = true

        btnChat.tap {
            let vc = SessionListVC()
            
            self.navigationController?.pushViewController(vc, animated: true)
        }
            
        self.setupImageSlides()
    }

    func setupImageSlides(){
        self.imageSlideView.setImageInputs([
            ImageSource(image: UIImage(named: "slide_1")!),
            ImageSource(image: UIImage(named: "slide_1")!),
            ImageSource(image: UIImage(named: "slide_1")!),
            ImageSource(image: UIImage(named: "slide_1")!),
            ImageSource(image: UIImage(named: "slide_1")!)
            ])
        self.imageSlideView.contentScaleMode = .scaleAspectFill
        self.imageSlideView.pageControlPosition = .hidden
        self.imageSlideView.slideshowInterval = 7
    }
  
    func addMenuView() -> [AnyObject] {
        guard self.menuItems.count > 0 else {
            return []
        }
        
        let layout: UICollectionViewFlowLayout = UICollectionViewFlowLayout()
        layout.sectionInset = UIEdgeInsets(top: 0, left: 0, bottom: 100, right: 0)
        layout.headerReferenceSize = CGSize(width: APP_WIDTH, height: 20)
        layout.itemSize = CGSize(width: APP_WIDTH / 3, height: 70)
        layout.minimumInteritemSpacing = 0
        layout.minimumLineSpacing = 1

        let mainHeight = self.mainView.bounds.height
        let frameRect = CGRect(x: 0, y: unreadChatViewHeight + taskViewHeight, width: APP_WIDTH, height: mainHeight - unreadChatViewHeight - taskViewHeight)
        mainMenuView = UICollectionView(frame: frameRect, collectionViewLayout: layout)
        mainMenuView.delegate = self
        mainMenuView.dataSource = self
        mainMenuView.backgroundColor = UIColor.white
        mainMenuView.alwaysBounceVertical = true
        mainMenuView.register(HeaderView.self, forSupplementaryViewOfKind: UICollectionElementKindSectionHeader, withReuseIdentifier: "HeaderView")
        mainMenuView.register(MenuCell.self, forCellWithReuseIdentifier: "MenuCell")
        self.mainView.addSubview(mainMenuView)

        return [mainMenuView]
    }
   
    func addUnreadChats() -> [AnyObject] {

        guard self.unreadSessions.count > 0 else {
            return []
        }

        var sessions = [AnyObject]()
        for i in 0 ..< self.unreadCellCount {
            let sessionView = UIView()
            let topView = UIView()
            let centerView = UIView()
            let titleLabel = UILabel()
            let avatarView = UIImageView()
            let dateLabel = UILabel()
            let contentLabel = UILabel()
            let markView = UIView()
            let btnDetail = UIButton()
            
            sessionView.frame = CGRect(x: 0, y: 0, width: APP_WIDTH, height:66.5)
            sessionView.setNeedsLayout()
            sessionView.layoutIfNeeded()
            sessionView.sv(
                topView.sv(
                    titleLabel.style(cellLabelStyle),
                    dateLabel.style(cellLabelStyle),
                    markView
                ),
                centerView.sv(
                    avatarView,
                    contentLabel.style(cellLabelStyle)
                ),
                btnDetail
            )
            
            titleLabel.font = .systemFont(ofSize: 8)
            dateLabel.font = .systemFont(ofSize: 8)
            dateLabel.textAlignment = .left
            
            markView.backgroundColor = UIColor.red
            markView.layer.cornerRadius = 3.5
            
            avatarView.layer.cornerRadius = 15
            avatarView.layer.masksToBounds = true
            
            contentLabel.numberOfLines = 1
            contentLabel.textAlignment = .left
            
            btnDetail.titleLabel?.font = .systemFont(ofSize: 10)
            btnDetail.setTitleColor(Colors.primary, for: .normal)
            
            sessionView.backgroundColor = UIColor.white
            
            topView.layout(|titleLabel.width(60).centerVertically()-20-dateLabel.centerVertically()-markView.size(7).centerVertically()-30-|)
            centerView.layout(|-15-avatarView.size(30).centerVertically(7)-35-contentLabel.centerVertically(2)-30-|)
            
            equalWidths(topView, centerView)
            
            sessionView.layout(
                |topView.top(3)|,
                |centerView.centerVertically()|,
                btnDetail.bottom(5).right(30)
            )
            
            // data
            let session = self.unreadSessions[i]
            titleLabel.text = "我的消息"
            let date = Date(timeIntervalSince1970: (session.lastMessage?.timestamp)!)
            dateLabel.text = dateFormat.string(from: date)
            contentLabel.text = session.lastMessage?.text
            btnDetail.setTitle("查看", for: .normal)
            let strUrl = API_URL+API_PHOTO+(session.lastMessage?.from)! as String
            let url = URL(string: strUrl)!
            avatarView.af_setImage(withURL: url, placeholderImage: UIImage(named: "avatar_user"))
            
            // tap event
            sessionView.tag = i
            let gesture = UITapGestureRecognizer(target: self, action: #selector (self.sessionAction(_:)))
            sessionView.addGestureRecognizer(gesture)
            
            self.mainView.addSubview(sessionView)

            sessions.append(|sessionView|)
        }
        
        return [sessions as AnyObject]
    }
    
    func addTask() -> [AnyObject] {
        guard self.taskList.count > 0 else {
            return []
        }

        let taskView = UIView()
        let leftView = UIView()
        let titleLabel = UILabel()
        let dateLabel = UILabel()
        let contentLabel = UILabel()
        let btnDetail = UIButton()
        
        taskView.frame = CGRect(x: 0, y: unreadChatViewHeight, width: APP_WIDTH, height:66.5)
        taskView.setNeedsLayout()
        taskView.layoutIfNeeded()
        taskView.sv(
            leftView.sv(
                titleLabel.style(cellLabelStyle),
                dateLabel.style(cellLabelStyle)
            ),
            contentLabel.style(cellLabelStyle),
            btnDetail
        )
        
        titleLabel.font = .systemFont(ofSize: 8)
        dateLabel.font = .systemFont(ofSize: 10)

        contentLabel.numberOfLines = 2
        contentLabel.textAlignment = .left
        
        btnDetail.titleLabel?.font = .systemFont(ofSize: 10)
        btnDetail.setTitleColor(Colors.primary, for: .normal)

        taskView.backgroundColor = UIColor.white
        
        equalWidths(titleLabel, dateLabel)
        leftView.layout(
            5,
            |titleLabel|,
            5,
            |dateLabel|
        )
        
        taskView.layout(
            |-leftView.width(60).height(66.5).centerVertically()-20-contentLabel.centerVertically()-30-|
        )
        
        btnDetail.bottom(5).right(30)
        
        // data
        let task = self.taskList[0]
        titleLabel.text = "我的任务"
        dateLabel.text = task.taskStartDate
        contentLabel.text = task.taskTheme+"\n"+task.taskDetails
        btnDetail.setTitle("查看", for: .normal)

        // tap event
        let gesture = UITapGestureRecognizer(target: self, action: #selector (self.taskAction(_:)))
        taskView.addGestureRecognizer(gesture)

        self.mainView.addSubview(taskView)

        return [taskView]
    }
    
    
    func sessionAction(_ sender:UITapGestureRecognizer){
        let i = sender.view?.tag
        let session = self.unreadSessions[i!]
        self.unreadSessions.remove(at: i!)
        self.refreshContents()

        let vc = SessionVC(session: session.session)
        self.navigationController!.pushViewController(vc!, animated: true)
    }
    
    func taskAction(_ sender:UITapGestureRecognizer){

        self.taskList.remove(at: 0)
        self.refreshContents()

        let menuVC = TaskMenuVC()
        let mainVC = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "TaskVC") as! TaskVC
        menuVC.delegate = mainVC
        let vc = SideMenuContainerVC(center: mainVC, leftViewController: menuVC)
        self.navigationController?.pushViewController(vc, animated: true)
    }

    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return menuItems.count
    }

    func collectionView(_ collectionView: UICollectionView, viewForSupplementaryElementOfKind kind: String, at indexPath: IndexPath) -> UICollectionReusableView {
        var reusableView : UICollectionReusableView? = nil
        
        // Create header
        if (kind == UICollectionElementKindSectionHeader) {
            let headerView = collectionView.dequeueReusableSupplementaryView(ofKind: UICollectionElementKindSectionHeader, withReuseIdentifier: "HeaderView", for: indexPath as IndexPath) as! HeaderView
            headerView.titleView.text = NSLocalizedString("my_applications", comment: "")
            
            reusableView = headerView
        }
        return reusableView!
    }

    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {

        let cell: MenuCell = collectionView.dequeueReusableCell(withReuseIdentifier: "MenuCell", for: indexPath as IndexPath) as! MenuCell
        
        cell.titleView.text = self.menuItems[indexPath.item].title
        cell.iconView.image = self.menuItems[indexPath.item].icon
        cell.btnView.isHidden = true
        
        return cell
    }

    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        let menuItem = menuItems[indexPath.row]
        let vc: UIViewController

        let index = Menu.menuMainTitleKeys.index(of: menuItem.key)

        
        if index == 0 {
            vc = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "ResumeVC")
        } else if index == 1 {
            vc = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "AttendanceInfoVC")
        } else if index == 2 {
            vc = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "SalaryVC")
        } else if index == 3 {
            vc = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "PerformanceVC")
        } else if index == 4 {
            vc = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "TrainingVC")
        } else if index == 5 {
            vc = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "LogVC")
        } else if index == 6 {
            let menuVC = ApprovalMenuVC()
            let mainVC = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "ApprovalVC") as! ApprovalVC
            menuVC.delegate = mainVC
            vc = SideMenuContainerVC(center: mainVC, leftViewController: menuVC)
        } else if index == 7 {
            let menuVC = TaskMenuVC()
            let mainVC = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "TaskVC") as! TaskVC
            menuVC.delegate = mainVC
            vc = SideMenuContainerVC(center: mainVC, leftViewController: menuVC)
        } else if index == 8 {
            vc = SubAcademicVC()
        } else if index == 9 {
            vc = SubAttendanceVC()
        } else if index == 10 {
            vc = SubSalaryVC()
        } else if index == 11 {
            vc = SubPerformanceVC()
        } else if index == 12 {
            vc = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "SubTrainingVC")
            //vc = SubTrainingVC()
        } else if index == 13 {
            vc = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "SubTaskVC")
        } else {
            vc = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "EditVC")
        }
        
        self.navigationController?.pushViewController(vc, animated: true)
    }

}

