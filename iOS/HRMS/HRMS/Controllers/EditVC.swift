//
//  ResumeVC.swift
//  HRMS
//
//  Created by Apollo on 1/5/17.
//  Copyright © 2017 Apollo. All rights reserved.
//

import UIKit

class EditVC: UIViewController, UICollectionViewDelegate, UICollectionViewDataSource{
    
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var btnEdit: UIButton!
    @IBOutlet weak var mainView: UIView!
    
    var mainMenuView: UICollectionView!
    var employeeMenuView: UICollectionView!
    var managerMenuView: UICollectionView!
    
    var mainMenuItems: [MenuItem] = []
    var employeeMenuItems: [MenuItem] = []
    var managerMenuItems: [MenuItem] = []
  
    var mainMenuViewHeight : CGFloat = 0.0
    var employeeMenuViewHeight : CGFloat = 0.0
    
    var isEditingMode: Bool = false
    var isManagerAccount = true

    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.loadMenu()

        self.setupView()
        
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
    
    func loadMenu(){
        mainMenuItems.removeAll()
        employeeMenuItems.removeAll()
        managerMenuItems.removeAll()

        /* load Menus */
        
        for titleKey in Menu.menuMainTitleKeys {
            let isMainMenu = UserDefaults.standard.bool(forKey: titleKey)
            let index = Menu.menuMainTitleKeys.index(of: titleKey)
            if index == 14 {
                continue
            }

            if !isManagerAccount && (index! < 14 && index! > 7) {
                continue
            }

            let menuItem = MenuItem(Menu.menuMainTypes[index!], titleKey, Menu.menuMainIcons[index!], isMainMenu)
            if isMainMenu {
                mainMenuItems.append(menuItem)
            } else {
                let type = menuItem.type
                switch type {
                case 1:
                    managerMenuItems.append(menuItem)
                    break
                case 0:
                    employeeMenuItems.append(menuItem)
                    break
                default:
                    employeeMenuItems.append(menuItem)
                }
            }
        }
    }
    
    func calculateHeights() {
        mainMenuViewHeight = mainMenuItems.count == 0 ? 0 : CGFloat((mainMenuItems.count / 4 + 1 ) * 70)
        employeeMenuViewHeight = employeeMenuItems.count == 0 ? 0 : CGFloat((employeeMenuItems.count / 4 + 1 ) * 70) + 20
    }

    func setupView(){
        titleLabel.text = NSLocalizedString("my_applications", comment: "")

        btnEdit.layer.borderColor = Colors.primary.cgColor
        btnEdit.tap(onBtnEditTapped)

        refreshContents()
    }

    func refreshContents() {
        if !isEditingMode {
            btnEdit.setTitle("编辑", for: .normal) //(NSLocalizedString("chat", comment: ""), for: .normal)
        } else {
            btnEdit.setTitle("元成", for: .normal) //(NSLocalizedString("chat", comment: ""), for: .normal)
        }
        
        for view in self.mainView.subviews{
            view.removeFromSuperview()
        }

        //self.mainMenuView = nil
        //self.employeeMenuView = nil
        //self.managerMenuView = nil

        self.calculateHeights()

        var layouts = [AnyObject]()
        layouts += self.addMainMenuView()
        layouts += self.addEmployeeMenuView()
        layouts += self.addManagerMenuView()
        
        self.mainView.layout(layouts)

        if self.mainMenuView != nil {
            self.mainMenuView.reloadData()
        }
        if self.employeeMenuView != nil {
            self.employeeMenuView.reloadData()
        }
        if self.managerMenuView != nil {
            self.managerMenuView.reloadData()
        }
    }

    func addMainMenuView() -> [AnyObject] {
        guard self.mainMenuItems.count > 0 else {
            return []
        }
        
        let layout: UICollectionViewFlowLayout = UICollectionViewFlowLayout()
        layout.sectionInset = UIEdgeInsets(top: 0, left: 0, bottom: 0, right: 0)
        layout.itemSize = CGSize(width: APP_WIDTH / 4, height: 70)
        layout.minimumInteritemSpacing = 0
        layout.minimumLineSpacing = 1
        
        let frameRect = CGRect(x: 0, y: 0, width: APP_WIDTH, height: mainMenuViewHeight)
        mainMenuView = UICollectionView(frame: frameRect, collectionViewLayout: layout)
        mainMenuView.delegate = self
        mainMenuView.dataSource = self
        mainMenuView.backgroundColor = UIColor.white
        mainMenuView.alwaysBounceVertical = true
        mainMenuView.register(MenuCell.self, forCellWithReuseIdentifier: "MainMenuCell")
        self.mainView.addSubview(mainMenuView)
        
        return [mainMenuView]
    }
    
    func addEmployeeMenuView() -> [AnyObject] {
        guard self.employeeMenuItems.count > 0 else {
            return []
        }
        
        let layout: UICollectionViewFlowLayout = UICollectionViewFlowLayout()
        layout.sectionInset = UIEdgeInsets(top: 0, left: 0, bottom: 0, right: 0)
        layout.headerReferenceSize = CGSize(width: APP_WIDTH, height: 20)
        layout.itemSize = CGSize(width: APP_WIDTH / 4, height: 70)
        layout.minimumInteritemSpacing = 0
        layout.minimumLineSpacing = 1

        let frameRect = CGRect(x: 0, y: mainMenuViewHeight, width: APP_WIDTH, height: employeeMenuViewHeight)
        employeeMenuView = UICollectionView(frame: frameRect, collectionViewLayout: layout)
        employeeMenuView.delegate = self
        employeeMenuView.dataSource = self
        employeeMenuView.backgroundColor = UIColor.white
        employeeMenuView.alwaysBounceVertical = true
        employeeMenuView.register(HeaderView.self, forSupplementaryViewOfKind: UICollectionElementKindSectionHeader, withReuseIdentifier: "EmployeeMenuHeader")
        employeeMenuView.register(MenuCell.self, forCellWithReuseIdentifier: "EmployeeMenuCell")
        self.mainView.addSubview(employeeMenuView)
        
        return [employeeMenuView]
    }
    
    func addManagerMenuView() -> [AnyObject] {
        // check isManagerAccount

        guard self.managerMenuItems.count > 0 else {
            return []
        }
        
        let layout: UICollectionViewFlowLayout = UICollectionViewFlowLayout()
        layout.sectionInset = UIEdgeInsets(top: 0, left: 0, bottom: 0, right: 0)
        layout.headerReferenceSize = CGSize(width: APP_WIDTH, height: 20)
        layout.itemSize = CGSize(width: APP_WIDTH / 4, height: 70)
        layout.minimumInteritemSpacing = 0
        layout.minimumLineSpacing = 1
        
        let mainHeight = self.mainView.bounds.height
        let frameRect = CGRect(x: 0, y: mainMenuViewHeight + employeeMenuViewHeight, width: APP_WIDTH, height: mainHeight - mainMenuViewHeight - employeeMenuViewHeight)
        managerMenuView = UICollectionView(frame: frameRect, collectionViewLayout: layout)
        managerMenuView.delegate = self
        managerMenuView.dataSource = self
        managerMenuView.backgroundColor = UIColor.white
        managerMenuView.alwaysBounceVertical = true
        managerMenuView.register(HeaderView.self, forSupplementaryViewOfKind: UICollectionElementKindSectionHeader, withReuseIdentifier: "ManagerMenuHeader")
        managerMenuView.register(MenuCell.self, forCellWithReuseIdentifier: "ManagerMenuCell")
        self.mainView.addSubview(managerMenuView)
        
        return [managerMenuView]
    }
    

    func onBtnEditTapped(){
        isEditingMode = !isEditingMode

        self.refreshContents()
    }

    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        if self.employeeMenuView != nil && collectionView == self.employeeMenuView {
            return employeeMenuItems.count
        } else if self.managerMenuView != nil && collectionView == self.managerMenuView {
            return managerMenuItems.count
        } else if self.mainMenuView != nil && collectionView == self.mainMenuView {
            return mainMenuItems.count
        } else {
            return 0
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, viewForSupplementaryElementOfKind kind: String, at indexPath: IndexPath) -> UICollectionReusableView {
        var reusableView : UICollectionReusableView? = nil
        
        // Create header
        if (kind == UICollectionElementKindSectionHeader) {
            if self.employeeMenuView != nil && collectionView == self.employeeMenuView {
                let headerView = collectionView.dequeueReusableSupplementaryView(ofKind: UICollectionElementKindSectionHeader, withReuseIdentifier: "EmployeeMenuHeader", for: indexPath as IndexPath) as! HeaderView
                headerView.titleView.text = NSLocalizedString("employee_applications", comment: "")
                reusableView = headerView
            } else if self.managerMenuView != nil && collectionView == self.managerMenuView {
                let headerView = collectionView.dequeueReusableSupplementaryView(ofKind: UICollectionElementKindSectionHeader, withReuseIdentifier: "ManagerMenuHeader", for: indexPath as IndexPath) as! HeaderView
                headerView.titleView.text = NSLocalizedString("manager_applications", comment: "")
                reusableView = headerView
            }
            
        }
        return reusableView!
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        
        let cell: MenuCell// = collectionView.dequeueReusableCell(withReuseIdentifier: "MenuCell", for: indexPath as IndexPath) as! MenuCell

        let menuItem: MenuItem
        var isMainMenu = false

        if self.employeeMenuView != nil && collectionView == self.employeeMenuView {
            cell = collectionView.dequeueReusableCell(withReuseIdentifier: "EmployeeMenuCell", for: indexPath as IndexPath) as! MenuCell
            menuItem = self.employeeMenuItems[indexPath.item]

            isMainMenu = false
        } else if self.managerMenuView != nil && collectionView == self.managerMenuView {
            cell = collectionView.dequeueReusableCell(withReuseIdentifier: "ManagerMenuCell", for: indexPath as IndexPath) as! MenuCell
            menuItem = self.managerMenuItems[indexPath.item]

            isMainMenu = false
        } else { //if collectionView == self.mainMenuView {
            cell = collectionView.dequeueReusableCell(withReuseIdentifier: "MainMenuCell", for: indexPath as IndexPath) as! MenuCell
            menuItem = self.mainMenuItems[indexPath.item]

            isMainMenu = true
        }

        cell.titleView.text = menuItem.title
        cell.iconView.image = menuItem.icon

        if isEditingMode {
            cell.btnView.isHidden = false
            if isMainMenu {
                cell.btnView.image = UIImage(named: "menu_delete")!
            } else {
                cell.btnView.image = UIImage(named: "menu_add")!
            }
        } else {
            cell.btnView.isHidden = true
        }
        
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        let menuItem: MenuItem
        if self.employeeMenuView != nil && collectionView == self.employeeMenuView {
            menuItem = self.employeeMenuItems[indexPath.item]
        } else if self.managerMenuView != nil && collectionView == self.managerMenuView {
            menuItem = self.managerMenuItems[indexPath.item]
        } else {//if collectionView == self.mainMenuView {
            menuItem = self.mainMenuItems[indexPath.item]
        }

        if isEditingMode {
            if self.employeeMenuView != nil && collectionView == self.employeeMenuView {
                self.employeeMenuItems.remove(at: indexPath.item)
                UserDefaults.standard.set(true, forKey: menuItem.key)
            } else if self.managerMenuView != nil && collectionView == self.managerMenuView {
                self.managerMenuItems.remove(at: indexPath.item)
                UserDefaults.standard.set(true, forKey: menuItem.key)
            } else {//if collectionView == self.mainMenuView {
                self.mainMenuItems.remove(at: indexPath.item)
                UserDefaults.standard.set(false, forKey: menuItem.key)
            }

            self.loadMenu()
            self.refreshContents()
        } else {
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
                vc = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "ResumeVC")
            }
            
            self.navigationController?.pushViewController(vc, animated: true)
        }
    }
}

