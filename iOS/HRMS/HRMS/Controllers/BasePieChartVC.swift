//
//  BasePieChartVC.swift
//  HRMS
//
//  Created by Apollo on 2/1/17.
//  Copyright © 2017 Apollo. All rights reserved.
//


import UIKit
import Charts
import SVProgressHUD
import AlamofireImage


class BasePieChartVC: UIViewController, UITableViewDataSource, UITableViewDelegate {
    
    var chartView = PieChartView()
    var tableView = UITableView()
    
    let BasePieChartCellIdentifier = "BasePieChartCell"
    
    var pieColors = [UIColor]()
    
    var members = [Member]()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setupUI()
        
        loadData()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        self.navigationController!.setNavigationBarHidden(false, animated: true)
        self.navigationItem.backBarButtonItem = UIBarButtonItem(title: "", style: .plain, target: nil, action: nil)
        
        self.navigationController?.navigationBar.frame = CGRect(x: 0, y: 0, width: (self.view.frame.width), height: 75)
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func setupUI() {
        self.view.backgroundColor = UIColor.groupTableViewBackground
        
        chartView.frame = CGRect(x: 0, y: 8, width: APP_WIDTH, height: APP_HEIGHT / 2 - 20)
        chartView.noDataText = "没有数据!"
        chartView.chartDescription?.text = ""
        chartView.xAxis.labelPosition = .bottom
        chartView.xAxis.drawGridLinesEnabled = false

        tableView.register(BaseMemberCell.self, forCellReuseIdentifier: BasePieChartCellIdentifier)
        tableView.frame = CGRect(x: 0, y: APP_HEIGHT / 2, width: APP_WIDTH, height: APP_HEIGHT / 2 - 20)
        tableView.delegate = self
        tableView.dataSource = self
        //tableView.separatorColor = UIColor.clear
        self.view.addSubview(chartView)
        self.view.addSubview(tableView)
        
    }
    
    func setChart(_ dataPoints: [String], values: [Double]) {
        chartView.noDataText = "没有数据!"

        
        var dataEntries: [PieChartDataEntry] = []
        
        for i in 0..<dataPoints.count {
            
            let dataEntry = PieChartDataEntry(value: values[i], label: dataPoints[i])
            dataEntries.append(dataEntry)
        }
        
        let chartDataSet = PieChartDataSet(values: dataEntries, label: "")
        if pieColors == nil || pieColors.isEmpty {
            for _ in 0..<dataPoints.count {
                let red = Double(arc4random_uniform(256))
                let green = Double(arc4random_uniform(256))
                let blue = Double(arc4random_uniform(256))
                
                let color = UIColor(red: CGFloat(red/255), green: CGFloat(green/255), blue: CGFloat(blue/255), alpha: 1)
                self.pieColors.append(color)
            }
        }
        chartDataSet.colors = pieColors
        let chartData = PieChartData(dataSet: chartDataSet) //xVals: titles,
        chartView.data = chartData
 
        chartView.animate(xAxisDuration: 2.0, yAxisDuration: 2.0)
    }
    
    func loadData() {
        
    }
    
    func loadMemberList() {
        
        SVProgressHUD.show()
        HRMSApi.POST(API_SUBORDINATES_LIST, params: ["memberID": User.getUserId()!]) { (response: SubordinateInfoResponse?, error: HRMSError?) in
            SVProgressHUD.dismiss()
            
            guard response != nil else {
                SVProgressHUD.showError(withStatus: error?.message)
                return
            }
            
            if response?.success == -1 {
                SVProgressHUD.showError(withStatus: "失败.")
                return
            }
            
            for companyInfo in (response?.data)! {
                for memberInfo in (companyInfo.children)! {
                    self.members.append(Member(id: memberInfo.pernr, name: memberInfo.nachn, orgname: companyInfo.name, plansname: memberInfo.plansname, email: memberInfo.email))
                }
            }
            
            self.tableView.reloadData()
        }
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 80
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return members.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: BasePieChartCellIdentifier, for: indexPath as IndexPath) as! BaseMemberCell
        
        let row = indexPath.row
        cell.nameLabel.text = self.members[row].name
        
        let strUrl = API_URL+API_PHOTO+self.members[row].id as String
        let url = URL(string: strUrl)!
        let filter = AspectScaledToFillSizeCircleFilter(size: cell.avatarView.frame.size)
        cell.avatarView.af_setImage(withURL: url, placeholderImage: UIImage(named: "avatar_user")?.af_imageRoundedIntoCircle(), filter: filter)
        
        return cell
    }
    
    // MARK:  UITableViewDelegate Methods
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
    }
}
