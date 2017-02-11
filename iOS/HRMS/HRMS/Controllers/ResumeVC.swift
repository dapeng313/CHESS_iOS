//
//  ResumeVC.swift
//  HRMS
//
//  Created by Apollo on 1/6/17.
//  Copyright © 2017 Apollo. All rights reserved.
//


import UIKit
import AlamofireImage

class ResumeVC: UIViewController, UICollectionViewDelegate, UICollectionViewDataSource{
    
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var btnBack: UIButton!

    @IBOutlet weak var plansLabel: UILabel!
    @IBOutlet weak var orgLabel: UILabel!
    @IBOutlet weak var mailLabel: UILabel!
    @IBOutlet weak var idLabel: UILabel!
    @IBOutlet weak var avatarView: UIImageView!

    @IBOutlet weak var mainView: UIView!


    var memberId: String?
    var user: Member?

    var resumeMenuView: UICollectionView!
    var resumeMenuItems: [MenuItem] = []

    
    override func viewDidLoad() {
        super.viewDidLoad()

        if self.memberId == nil || self.memberId?.isEmpty == true {
            self.memberId = User.getUserId()
        }

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
        resumeMenuItems.removeAll()

        /* load Menus */
        for titleKey in Menu.menuResumeTitleKeys {
            let index = Menu.menuResumeTitleKeys.index(of: titleKey)
            let menuItem = MenuItem(0, titleKey, Menu.menuResumeIcons[index!], true)
            resumeMenuItems.append(menuItem)
        }
    }
    
    func setupView(){
        
        if self.memberId == nil || self.memberId?.isEmpty == true || self.memberId == User.getUserId(){
            titleLabel.text = "我的经历"//NSLocalizedString("my_applications", comment: "")

            idLabel.text = throwEmpty(User.getUserNachn())!
            mailLabel.text = throwEmpty(User.getUserEmail())!
            orgLabel.text = throwEmpty(User.getUserOrgehname())!
            plansLabel.text = throwEmpty(User.getUserPlansname())!
            
            let strUrl = API_URL+API_PHOTO+memberId! as String
            let url = URL(string: strUrl)!
            let filter = AspectScaledToFillSizeCircleFilter(size: avatarView.frame.size)
            avatarView.af_setImage(withURL: url, placeholderImage: UIImage(named: "avatar_user")?.af_imageRoundedIntoCircle(), filter: filter)

        } else {
            titleLabel.text = "下属经历"//NSLocalizedString("my_applications", comment: "")
            idLabel.text = throwEmpty(user?.name)!
            mailLabel.text = throwEmpty(user?.email)!
            orgLabel.text = throwEmpty(user?.orgname)!
            plansLabel.text = throwEmpty(user?.plansname)!
            
            let strUrl = API_URL+API_PHOTO+memberId! as String
            let url = URL(string: strUrl)!
            let filter = AspectScaledToFillSizeCircleFilter(size: avatarView.frame.size)
            avatarView.af_setImage(withURL: url, placeholderImage: UIImage(named: "avatar_user")?.af_imageRoundedIntoCircle(), filter: filter)

        }

        btnBack.tap(onBtnBack)

        var layouts = [AnyObject]()
        layouts += self.addResumeMenuView()

        self.mainView.layout(layouts)
    }
    
    func onBtnBack(){
        self.navigationController?.popViewController(animated: true)
    }
    
    func addResumeMenuView() -> [AnyObject] {
        guard self.resumeMenuItems.count > 0 else {
            return []
        }
        
        let layout: UICollectionViewFlowLayout = UICollectionViewFlowLayout()
        layout.sectionInset = UIEdgeInsets(top: 0, left: 0, bottom: 0, right: 0)
        layout.itemSize = CGSize(width: APP_WIDTH / 3, height: 80)
        layout.minimumInteritemSpacing = 0
        layout.minimumLineSpacing = 1
        
        let frameRect = CGRect(x: 0, y: 0, width: APP_WIDTH, height: self.mainView.frame.height)
        resumeMenuView = UICollectionView(frame: frameRect, collectionViewLayout: layout)
        resumeMenuView.delegate = self
        resumeMenuView.dataSource = self
        resumeMenuView.backgroundColor = UIColor.white
        resumeMenuView.alwaysBounceVertical = true
        resumeMenuView.register(MenuCell.self, forCellWithReuseIdentifier: "MenuCell")
        self.mainView.addSubview(resumeMenuView)
        
        return [resumeMenuView]
    }

    //Menu Collections
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return resumeMenuItems.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "MenuCell", for: indexPath as IndexPath) as! MenuCell
        
        let menuItem = self.resumeMenuItems[indexPath.item]
    
        cell.titleView.text = menuItem.title
        cell.iconView.image = menuItem.icon

        return cell
    }

    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        let menuItem: MenuItem
        menuItem = self.resumeMenuItems[indexPath.item]

        let vc = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "ResumeDetailVC") as! ResumeDetailVC
        vc.memberId = self.memberId
        vc.user = self.user
        vc.vcIndex = Menu.menuResumeTitleKeys.index(of: menuItem.key)!
        
        self.navigationController?.pushViewController(vc, animated: true)
    }
}

