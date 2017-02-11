//
//  SalaryVC.swift
//  HRMS
//
//  Created by Apollo on 1/30/17.
//  Copyright © 2017 Apollo. All rights reserved.
//


import UIKit
import SVProgressHUD

class SalaryVC: UIViewController {

    @IBOutlet weak var monthLabel: UILabel!
    @IBOutlet weak var btnBefore: UIButton!
    @IBOutlet weak var btnAfter: UIButton!
    @IBOutlet weak var totalLabel: UILabel!
    @IBOutlet weak var lblDetail1: UILabel!
    @IBOutlet weak var lblDetail2: UILabel!
    @IBOutlet weak var lblDetail3: UILabel!
    @IBOutlet weak var lblDetail4: UILabel!
    @IBOutlet weak var btnDetail1: UIButton!
    @IBOutlet weak var btnDetail2: UIButton!
    @IBOutlet weak var btnDetail3: UIButton!
    @IBOutlet weak var btnDetail4: UIButton!
    @IBOutlet weak var scrollView: UIScrollView!
    @IBOutlet weak var contentsView: UIView!
    
    var memberId: String?

    var current = Date()
    var py2000: PY2000?
    var py2001: PY2001?
    var py2002: PY2002?
    
    fileprivate lazy var dateFormat: DateFormatter = {
        let formatter = DateFormatter()
        formatter.dateFormat = "yyyy-MM"
        return formatter
    }()

    override func viewDidLoad() {
        super.viewDidLoad()
        
        if self.memberId == nil || self.memberId?.isEmpty == true {
            self.memberId = User.getUserId()
        }

        setupUI()
        
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        self.navigationController!.setNavigationBarHidden(false, animated: true)
        self.navigationItem.backBarButtonItem = UIBarButtonItem(title: "", style: .plain, target: nil, action: nil)
        
        
        if self.memberId == nil || self.memberId?.isEmpty == true || self.memberId == User.getUserId() {
            self.navigationItem.title = "我的薪酬"//NSLocalizedString("setting", comment: "")
        } else {
            self.navigationItem.title = "下属薪酬"//NSLocalizedString("setting", comment: "")
        }
        self.navigationController?.navigationBar.frame = CGRect(x: 0, y: 0, width: (self.view.frame.width), height: 75)
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func setupUI() {

        btnDetail1.layer.borderColor = UIColor.darkGray.cgColor
        btnDetail2.layer.borderColor = UIColor.darkGray.cgColor
        btnDetail3.layer.borderColor = UIColor.darkGray.cgColor
        btnDetail4.layer.borderColor = UIColor.darkGray.cgColor

        btnDetail1.tap(onBtnDetail1Tapped)
        btnDetail2.tap(onBtnDetail2Tapped)
        btnDetail3.tap(onBtnDetail3Tapped)
        btnDetail4.tap(onBtnDetail4Tapped)

        btnAfter.tap {
            self.current = self.current.getNextMonth()!
            self.refresh()
        }
        btnBefore.tap {
            self.current = self.current.getPreviousMonth()!
            self.refresh()
        }
    }

    func refresh() {
        let year = Calendar.current.component(.year, from: current)
        let month = Calendar.current.component(.month, from: current)
        monthLabel.text = String(year)+"年 "+String(month)+"月"

        loadData()
    }
    
    
    func loadData() {
        self.totalLabel.text = "0"
        self.lblDetail1.text = "0"
        self.lblDetail2.text = "0"
        self.lblDetail3.text = "0"
        self.lblDetail4.text = "0"
       
        SVProgressHUD.show()
        HRMSApi.POST(API_SALARY_DETAILS, params: ["PERNR": self.memberId!, "PAYDATE": dateFormat.string(from: current)]) { (salaryInfo: SalaryInfoResponse?, error: HRMSError?) in
            SVProgressHUD.dismiss()
            
            guard salaryInfo != nil else {
                SVProgressHUD.showError(withStatus: error?.message)
                return
            }
            
            if salaryInfo?.success == -1 {
                SVProgressHUD.showError(withStatus: "失败.")
                return
            }

            self.py2000 = salaryInfo?.py2000
            self.py2001 = salaryInfo?.py2001
            self.py2002 = salaryInfo?.py2002

            //应发工资
            let v1 = (self.py2000?.p1000)! + (self.py2000?.p1001)! + (self.py2000?.p1002)! + (self.py2000?.p1003)! + (self.py2000?.p1004)! +
                (self.py2000?.p1005)! + (self.py2000?.p1006)! + (self.py2001?.p2000)! + (self.py2001?.p2001)! + (self.py2001?.p2002)! + (self.py2002?.nzjj)!
            //社会保险
            let v2 = (self.py2000?.p3000)! + (self.py2000?.p3002)! + (self.py2000?.p3004)! + (self.py2000?.p3008)!
            //个人所得税
            let v3 = (self.py2000?.GRSDS)! + (self.py2001?.JJGS)! + (self.py2002?.JJGS)!
            //其他扣除
            let v4 = (self.py2000?.p1007)! + (self.py2000?.p1008)! + (self.py2000?.p1009)! + (self.py2000?.p1010)!

            self.totalLabel.text = String((self.py2000?.SFGZ)!)+"元"
            self.lblDetail1.text = String(v1)+"元"
            self.lblDetail2.text = String(v2)+"元"
            self.lblDetail3.text = String(v3)+"元"
            self.lblDetail4.text = String(v4)+"元"
        }

    }

    func onBtnDetail1Tapped() {
        let vc = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "SalaryDetailVC") as! SalaryDetailVC
        vc.salaryType = 0

        var sumPy2000 = 0 as Double
        if self.py2000 == nil {
            for _ in 0...6 {
                vc.salaryData.append(0)
            }
        } else {
            vc.salaryData.append((py2000?.p1000)!)
            vc.salaryData.append((py2000?.p1001)!)
            vc.salaryData.append((py2000?.p1002)!)
            vc.salaryData.append((py2000?.p1003)!)
            vc.salaryData.append((py2000?.p1004)!)
            vc.salaryData.append((py2000?.p1005)!)
            vc.salaryData.append((py2000?.p1006)!)
            sumPy2000 = (py2000?.p1000)! + (py2000?.p1001)! + (py2000?.p1002)! + (py2000?.p1003)! +
                (py2000?.p1004)! + (py2000?.p1005)! + (py2000?.p1006)!
        }

        var sumPy2001 = 0 as Double
        if self.py2001 == nil {
            for _ in 0...2 {
                vc.salaryData.append(0)
            }
        } else {
            vc.salaryData.append((py2001?.p2000)!)
            vc.salaryData.append((py2001?.p2001)!)
            vc.salaryData.append((py2001?.p2002)!)
            sumPy2001 = (py2001?.p2000)! + (py2001?.p2001)! + (py2001?.p2002)!
        }

        if self.py2002 == nil {
            vc.salaryData.append(0)
            vc.salaryData.append(sumPy2000 + sumPy2001 + 0)
        } else {
            vc.salaryData.append((py2002?.nzjj)!)
            vc.salaryData.append(sumPy2000 + sumPy2001 + (py2002?.nzjj)!)
        }

        self.navigationController?.pushViewController(vc, animated: true)
    }
    
    func onBtnDetail2Tapped() {
        let vc = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "SalaryDetailVC") as! SalaryDetailVC
        vc.salaryType = 1

        if self.py2000 == nil {
            for _ in 0...4 {
                vc.salaryData.append(0)
            }
            for _ in 0...6 {
                vc.salaryData2.append(0)
            }
        } else {
            vc.salaryData.append((py2000?.p3000)!)
            vc.salaryData.append((py2000?.p3002)!)
            vc.salaryData.append((py2000?.p3004)!)
            vc.salaryData.append((py2000?.p3008)!)
            vc.salaryData.append((py2000?.p3000)! + (py2000?.p3002)! + (py2000?.p3004)! + (py2000?.p3008)!)
            vc.salaryData2.append((py2000?.p3001)!)
            vc.salaryData2.append((py2000?.p3003)!)
            vc.salaryData2.append((py2000?.p3005)!)
            vc.salaryData2.append((py2000?.p3006)!)
            vc.salaryData2.append((py2000?.p3007)!)
            vc.salaryData2.append((py2000?.p3009)!)
            vc.salaryData2.append((py2000?.p3001)! + (py2000?.p3003)! + (py2000?.p3005)! + (py2000?.p3006)! + (py2000?.p3007)! + (py2000?.p3009)!)
        }

        self.navigationController?.pushViewController(vc, animated: true)
    }
    
    func onBtnDetail3Tapped() {
    }
    
    func onBtnDetail4Tapped() {
        let vc = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "SalaryDetailVC") as! SalaryDetailVC
        vc.salaryType = 3
        
        if self.py2000 == nil {
            for _ in 0...4 {
                vc.salaryData.append(0)
            }
        } else {
            vc.salaryData.append((py2000?.p1007)!)
            vc.salaryData.append((py2000?.p1008)!)
            vc.salaryData.append((py2000?.p1009)!)
            vc.salaryData.append((py2000?.p1010)!)
            vc.salaryData.append((py2000?.p1007)! + (py2000?.p1008)! + (py2000?.p1009)! + (py2000?.p1010)!)
        }


        self.navigationController?.pushViewController(vc, animated: true)
    }
}


