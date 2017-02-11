//
//  Menu.swift
//  HRMS
//
//  Created by Apollo on 1/6/17.
//  Copyright © 2017 Apollo. All rights reserved.
//

import Foundation
import UIKit


struct MenuItem {
    var type: Int = 0
    var title: String = ""
    var key: String = ""
    var icon: UIImage?
    var isMainMenu: Bool = true
    
    init() {
        self.type = 0
        self.title = "More"
        self.key = "More"
        self.icon = UIImage(named: "more.png")!
        self.isMainMenu = false
    }

    init(_ type: Int, _ titleKey: String, _ icon: UIImage?, _ isMainMenu:Bool) {
        self.type = type
        self.title = NSLocalizedString(titleKey, comment: "")
        self.key = titleKey
        self.icon = icon
        self.isMainMenu = isMainMenu
    }
}

class Menu {

    static let menuMainTitleKeys = ["my_resume", "my_attendence", "my_wages", "my_exam", "my_train",
                                 "my_journal", "my_approval", "my_task", "my_staff", "staff_attendence",
                                 "staff_wages", "staff_exam", "staff_train", "staff_task", "menu_more"]

    static var menuMainIcons: [UIImage] = [
        UIImage(named: "resume.png")!, UIImage(named: "attendence.png")!, UIImage(named: "wages.png")!, UIImage(named: "exam.png")!, UIImage(named: "train.png")!,
        UIImage(named: "journal.png")!, UIImage(named: "approval.png")!, UIImage(named: "task.png")!, UIImage(named: "mng_staff.png")!, UIImage(named: "mng_attendence.png")!,
        UIImage(named: "mng_wages.png")!, UIImage(named: "mng_exam.png")!, UIImage(named: "mng_train.png")!, UIImage(named: "mng_task.png")!, UIImage(named: "more.png")!]

    static let menuMainTypes = [0, 0, 0, 0, 0, 0, 0, 0, 1, 1, 1, 1, 1, 1, -1]

    
    static let menuResumeTitleKeys = ["resume_main", "resume_contract", "resume_event", "resume_edu", "resume_work",
                                    "resume_training", "resume_level"]
    
    static var menuResumeIcons: [UIImage] = [
        UIImage(named: "resume_main")!, UIImage(named: "resume_contract")!, UIImage(named: "resume_event")!, UIImage(named: "resume_edu")!, UIImage(named: "resume_work")!,
        UIImage(named: "resume_training")!, UIImage(named: "resume_level")!]

}
