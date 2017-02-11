//
//  ResumeDetailVC.swift
//  HRMS
//
//  Created by Apollo on 1/23/17.
//  Copyright © 2017 Apollo. All rights reserved.
//

import UIKit
import AlamofireImage

class ResumeDetailVC: UIViewController, EMPageViewControllerDataSource, EMPageViewControllerDelegate {
    
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var btnBack: UIButton!

    @IBOutlet weak var plansLabel: UILabel!
    @IBOutlet weak var orgLabel: UILabel!
    @IBOutlet weak var mailLabel: UILabel!
    @IBOutlet weak var idLabel: UILabel!
    @IBOutlet weak var avatarView: UIImageView!
    
    @IBOutlet weak var btnBackward: UIButton!
    @IBOutlet weak var btnForward: UIButton!

    var memberId: String?
    var user: Member?

    var pageViewController: EMPageViewController?
    var vcIndex: Int = 0

    var vcList: [UIViewController] = []


    override func viewDidLoad() {
        super.viewDidLoad()

        if self.memberId == nil || self.memberId?.isEmpty == true {
            self.memberId = User.getUserId()
        }

        self.loadVCs()
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


    func loadVCs() {
        
        let vc1 = ResumeContractVC()
        vc1.memberId = self.memberId
        let vc2 = ResumeEventVC()
        vc2.memberId = self.memberId
        let vc3 = ResumeEducationVC()
        vc3.memberId = self.memberId
        let vc4 = ResumeWorkVC()
        vc4.memberId = self.memberId
        let vc5 = ResumeTrainVC()
        vc5.memberId = self.memberId
        let vc6 = ResumeLevelVC()
        vc6.memberId = self.memberId
        let vc0 = ResumeMainVC()
        vc0.memberId = self.memberId

        self.vcList = [vc0, vc1, vc2, vc3, vc4, vc5, vc6]
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
        
        // Instantiate EMPageViewController and set the data source and delegate to 'self'
        let pageViewController = EMPageViewController()
        pageViewController.dataSource = self
        pageViewController.delegate = self
        
        // Set the initially selected view controller
        // IMPORTANT: If you are using a dataSource, make sure you set it BEFORE calling selectViewController:direction:animated:completion
        let currentViewController = self.viewController(at: vcIndex)! as! BaseResumeInfoVC
//        currentViewController.loadInfo()
        pageViewController.selectViewController(currentViewController, direction: .forward, animated: false, completion: nil)
        
        // Add EMPageViewController to the root view controller
        self.addChildViewController(pageViewController)
        self.view.insertSubview(pageViewController.view, at: 0) // Insert the page controller view below the navigation buttons
        pageViewController.didMove(toParentViewController: self)
        
        self.pageViewController = pageViewController
    }
    
    func onBtnBack(){
        self.navigationController?.popViewController(animated: true)
    }
    
    
    // MARK: - Convienient EMPageViewController scroll / transition methods
    
    @IBAction func forward(_ sender: AnyObject) {
        self.pageViewController!.scrollForward(animated: true, completion: nil)
    }
    
    @IBAction func backward(_ sender: AnyObject) {
        self.pageViewController!.scrollReverse(animated: true, completion: nil)
    }

    // MARK: - EMPageViewController Data Source
    
    func em_pageViewController(_ pageViewController: EMPageViewController, viewControllerBeforeViewController viewController: UIViewController) -> UIViewController? {
        if let viewControllerIndex = self.index(of: viewController) {
            let beforeViewController = self.viewController(at: viewControllerIndex - 1)
            return beforeViewController
        } else {
            return nil
        }
    }
    
    func em_pageViewController(_ pageViewController: EMPageViewController, viewControllerAfterViewController viewController: UIViewController) -> UIViewController? {
        if let viewControllerIndex = self.index(of: viewController ) {
            let afterViewController = self.viewController(at: viewControllerIndex + 1)
            return afterViewController
        } else {
            return nil
        }
    }
    
    func viewController(at index: Int) -> UIViewController? {
        if (index < 0) || (index >= 7) {
            return nil
        }

        let viewController = vcList[index]
        return viewController
    }
    
    func index(of viewController: UIViewController) -> Int? {
//        if viewController != nil {
            return self.vcList.index(of: viewController)
//        } else {
//            return nil
//        }
    }
    
    // MARK: - EMPageViewController Delegate
    
    func em_pageViewController(_ pageViewController: EMPageViewController, willStartScrollingFrom startViewController: UIViewController, destinationViewController: UIViewController) {

    }
    
    func em_pageViewController(_ pageViewController: EMPageViewController, isScrollingFrom startViewController: UIViewController, destinationViewController: UIViewController, progress: CGFloat) {

    }
    
    func em_pageViewController(_ pageViewController: EMPageViewController, didFinishScrollingFrom startViewController: UIViewController?, destinationViewController: UIViewController, transitionSuccessful: Bool) {
        let destinationViewController = destinationViewController as! BaseResumeInfoVC
//        destinationViewController.loadInfo()

        // If the transition is successful, the new selected view controller is the destination view controller.
        // If it wasn't successful, the selected view controller is the start view controller
        if transitionSuccessful {
            
            if (self.index(of: destinationViewController) == 0) {
                self.btnBackward.isEnabled = false
            } else {
                self.btnBackward.isEnabled = true
            }
            
            if (self.index(of: destinationViewController) == self.vcList.count - 1) {
                self.btnForward.isEnabled = false
            } else {
                self.btnForward.isEnabled = true
            }
        }

    }

}

