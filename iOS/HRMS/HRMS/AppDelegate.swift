//
//  AppDelegate.swift
//  HRMS
//
//  Created by Apollo on 1/3/17.
//  Copyright © 2017 Apollo. All rights reserved.
//

import UIKit

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate, NIMLoginManagerDelegate {

    var window: UIWindow?


    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplicationLaunchOptionsKey: Any]?) -> Bool {
        // Override point for customization after application launch.

        AMapServices.shared().apiKey = AMAP_API_KEY

        
        //注册APP，请将 NIMSDKAppKey 换成您自己申请的App Key
        NIMSDK.shared().register(withAppID: NIM_SDK_APP_KEY, cerName: NIM_SDK_CER_NAME)

        //注册自定义消息的解析器
        NIMCustomObject.registerCustomDecoder(CustomAttachmentDecoder())
        //注册 NIMKit 自定义排版配置
        NIMKit.shared().registerLayoutConfig(CellLayoutConfig.self)
        NIMSDK.shared().loginManager.add(self as NIMLoginManagerDelegate)

        setupMainViewController()
        
        setupNavigationBar()

        return true
    }

    func applicationWillResignActive(_ application: UIApplication) {
        // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
        // Use this method to pause ongoing tasks, disable timers, and invalidate graphics rendering callbacks. Games should use this method to pause the game.
    }

    func applicationDidEnterBackground(_ application: UIApplication) {
        // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later.
        // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
    }

    func applicationWillEnterForeground(_ application: UIApplication) {
        // Called as part of the transition from the background to the active state; here you can undo many of the changes made on entering the background.
    }

    func applicationDidBecomeActive(_ application: UIApplication) {
        // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
    }

    func applicationWillTerminate(_ application: UIApplication) {
        // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
    }
    
    func application(_ app: UIApplication, didRegisterForRemoteNotificationsWithDeviceToken deviceToken: Data) {
        NIMSDK.shared().updateApnsToken(deviceToken)
    }

    
    func setupMainViewController() {

        //auto loginuserdefault
        let account = UserDefaults.standard.string(forKey: "account_id") as String? //"dapengwang1987313831"//"00014115"
        let token = UserDefaults.standard.string(forKey: "token") as String? //"85064efb60a9601805dcea56ec5402f7"//"c72c8d4fed9cb5d7428e691bee2f5f54"
        
        self.window = UIWindow(frame: UIScreen.main.bounds)
        var mainVC = UIViewController()

        if account == nil || account == nil || account!.isEmpty || token!.isEmpty {
            mainVC = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "LoginVC")
        } else {
            mainVC = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "HomeVC")
            
            NIMSDK.shared().loginManager.autoLogin(account!, token: token!)
        }

        let navigationController = UINavigationController(rootViewController: mainVC)
        self.window?.rootViewController = navigationController
        self.window?.makeKeyAndVisible()
    }
    
    func setupNavigationBar() {

        UINavigationBar.appearance().barTintColor = Colors.primary
        UINavigationBar.appearance().tintColor = UIColor.white
        UINavigationBar.appearance().isTranslucent = false
        UINavigationBar.appearance().titleTextAttributes = [NSFontAttributeName: UIFont.systemFont(ofSize: 20), NSForegroundColorAttributeName: UIColor.white]
        let backImage: UIImage = UIImage(named: "back")!.withRenderingMode(.alwaysTemplate).withAlignmentRectInsets(UIEdgeInsetsMake(0, 0, 0, 0))
        UINavigationBar.appearance().backIndicatorImage = backImage
        UINavigationBar.appearance().backIndicatorTransitionMaskImage = backImage
       
        UIApplication.shared.statusBarStyle = UIStatusBarStyle.lightContent
    }

// MARK: - NIMLoginManagerDelegate
    
    func onKick(_ code: NIMKickReason, clientType: NIMLoginClientType) {
        
        NIMSDK.shared().loginManager.logout({(_ error: Error?) -> Void in
            NotificationCenter.default.post(name: NSNotification.Name(rawValue: "NotificationLogout"), object: nil)
            var alert = UIAlertView(title: "下线通知", message: "", delegate: nil, cancelButtonTitle: "确定", otherButtonTitles: "")
            alert.show()
        })
    }

    func onAutoLoginFailed(_ error: Error?) {
        //只有连接发生严重错误才会走这个回调，在这个回调里应该登出，返回界面等待用户手动重新登录。

        NIMSDK.shared().loginManager.logout({(_ error: Error?) -> Void in
            NotificationCenter.default.post(name: NSNotification.Name(rawValue: "NotificationLogout"), object: nil)
        })
    }
}

