//
//  LogInfo.swift
//  HRMS
//
//  Created by Apollo on 1/31/17.
//  Copyright © 2017 Apollo. All rights reserved.
//


import Foundation
import ObjectMapper

class LogInfoResponse: HRMSResponse {
    var data: [LogInfo]?
    
    required init?(map: Map) { super.init(map: map) }
    
    override func mapping(map: Map) {
        super.mapping(map: map)
        
        data <- map["logList"]
    }
}

class LogInfo: HRMSModel {

    var skip: Int = 0
    var rows: Int = 0
    var logId: Int = 0
    var applyId: String = ""
    var workDate: String = "2016-12-01"
    var workHour: String = ""
    var workPlace: String = ""
    var workProperty: String = ""
    var workContent: String = ""
    var releaseFlag: String = ""
    
    required init?(map: Map) { super.init(map: map) }
    
    override func mapping(map: Map) {
        
        skip <- map["skip"]
        rows <- map["rows"]
        logId <- map["logId"]
        applyId <- map["applyId"]
        workDate <- map["workDate"]
        workHour <- map["workHour"]
        workPlace <- map["workPlace"]
        workProperty <- map["workProperty"]
        workContent <- map["workContent"]
        releaseFlag <- map["releaseFlag"]
    }
}
