//
//  SubSalaryInfo.swift
//  HRMS
//
//  Created by Apollo on 2/1/17.
//  Copyright © 2017 Apollo. All rights reserved.
//

import Foundation
import ObjectMapper

class SubSalaryInfo: HRMSModel {


    var pernr: String = ""
    var nachn: String = ""
    var paydate: String = "0000-00"
    var payroll: Int = 0
    var nzjj: Int = 0
    var p101: Double = 0
    var p102: Double = 0
    var p103: Double = 0
    var p105: Double = 0
    var p201: Double = 0
    var p303: Double = 0
    
    required init?(map: Map) { super.init(map: map) }
    
    override func mapping(map: Map) {

        pernr <- map["pernr"]
        nachn <- map["nachn"]
        paydate <- map["paydate"]
        payroll <- map["payroll"]
        nzjj <- map["nzjj"]
        p101 <- map["p101"]
        p102 <- map["p102"]
        p103 <- map["p103"]
        p105 <- map["p105"]
        p201 <- map["p201"]
        p303 <- map["p303"]
    }
}

class SubSalaryInfoResponse: HRMSResponse {
    var data: [SubSalaryInfo]?
    var monthList: [String]?
    
    required init?(map: Map) { super.init(map: map) }
    
    override func mapping(map: Map) {
        super.mapping(map: map)
        
        data <- map["salaryList"]
        monthList <- map["monthList"]
    }
}
