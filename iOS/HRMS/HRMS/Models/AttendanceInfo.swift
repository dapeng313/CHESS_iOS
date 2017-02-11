//
//  AttendanceInfo.swift
//  HRMS
//
//  Created by Apollo on 1/27/17.
//  Copyright © 2017 Apollo. All rights reserved.
//


import Foundation
import ObjectMapper

class AttendanceInfoResponse: HRMSResponse {
    var data: [AttendanceInfo]?
    
    required init?(map: Map) { super.init(map: map) }
    
    override func mapping(map: Map) {
        super.mapping(map: map)
        
        data <- map["attendancelist"]
    }
}

class AttendanceInfo: HRMSModel {

    static let ABSENCE         = 1;
    static let TRAVEL          = 2;
    static let OVERTIME        = 3;
    static let MISSING_CARD    = 4;
    static let LATE            = 5;
    static let LEAVE_EARLY     = 6;
    static let NORMAL          = 7;

    static let TYPE = ["缺勤", "出差", "加班", "缺卡", "迟到", "早退", "正常"]

    var type: Int = 0
    var pernr: String = ""
    var date: String = "2016-12-01"
    var intype: Int = 0
    var outype: Int = 0
    var reason: String = ""

    
    required init?(map: Map) { super.init(map: map) }
    
    override func mapping(map: Map) {
        
        type <- map["type"]
        pernr <- map["pernr"]
        date <- map["date"]
        intype <- map["intype"]
        outype <- map["outype"]
        reason <- map["reason"]
    }
    
}
