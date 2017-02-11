//
//  BaseBarChartVC.swift
//  HRMS
//
//  Created by Apollo on 2/1/17.
//  Copyright © 2017 Apollo. All rights reserved.
//

import UIKit
import Charts
import SVProgressHUD
import AlamofireImage


class BaseBarChartVC: UIViewController, UITableViewDataSource, UITableViewDelegate {
    
    var chartView = BarChartView()
    var tableView = UITableView()

    let BaseBarChartCellIdentifier = "BaseBarChartCell"
    
    var barColors = [UIColor]()
    
    var members = [Member]()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setupUI()
 
        loadMemberList()
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
        chartView.xAxis.granularityEnabled = true
        chartView.xAxis.granularity = 1
        chartView.rightAxis.enabled = false
        chartView.rightAxis.drawGridLinesEnabled = false
        chartView.leftAxis.drawGridLinesEnabled = false

        tableView.register(BaseMemberCell.self, forCellReuseIdentifier: BaseBarChartCellIdentifier)
        tableView.frame = CGRect(x: 0, y: APP_HEIGHT / 2, width: APP_WIDTH, height: APP_HEIGHT / 2 - 20)
        tableView.contentInset = UIEdgeInsets(top: 0, left: 0, bottom: 100, right: 0)
        tableView.delegate = self
        tableView.dataSource = self
        //tableView.separatorColor = UIColor.clear
        self.view.addSubview(chartView)
        self.view.addSubview(tableView)

    }
    
    func setChart(_ dataPoints: [String], values: [Double]) {
        chartView.noDataText = "没有数据!"
        
        let formato: BarChartFormatter = BarChartFormatter()
        let xaxis: XAxis = XAxis()
        formato.strings = dataPoints
        
        var dataEntries: [BarChartDataEntry] = []
        
        for i in 0..<dataPoints.count {
            formato.stringForValue(Double(i), axis: xaxis)
            
            let dataEntry = BarChartDataEntry(x: Double(i), y: values[i])
            dataEntries.append(dataEntry)
        }
        
        xaxis.valueFormatter = formato
        chartView.xAxis.valueFormatter = xaxis.valueFormatter
        
        let chartDataSet = BarChartDataSet(values: dataEntries, label: "")
        if barColors == nil || barColors.isEmpty {
            for _ in 0..<dataPoints.count {
                let red = Double(arc4random_uniform(256))
                let green = Double(arc4random_uniform(256))
                let blue = Double(arc4random_uniform(256))
                
                let color = UIColor(red: CGFloat(red/255), green: CGFloat(green/255), blue: CGFloat(blue/255), alpha: 1)
                self.barColors.append(color)
            }
        }
        chartDataSet.setColors(barColors, alpha: 0.5)
        let chartData = BarChartData(dataSet: chartDataSet) //xVals: titles,
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
        let cell = tableView.dequeueReusableCell(withIdentifier: BaseBarChartCellIdentifier, for: indexPath as IndexPath) as! BaseMemberCell
        
        let row = indexPath.row
        cell.nameLabel.text = self.members[row].name
        
        let strUrl = API_URL+API_PHOTO+self.members[row].id as String
        let url = URL(string: strUrl)!
        let filter = AspectScaledToFillSizeCircleFilter(size: cell.avatarView.frame.size)
        cell.avatarView.af_setImage(withURL: url, placeholderImage: UIImage(named: "avatar_user"))//?.af_imageRoundedIntoCircle(), filter: filter)
        
        return cell
    }
    
    // MARK:  UITableViewDelegate Methods
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
    }
}
