//
//  PerformanceInfo.swift
//  HRMS
//
//  Created by Apollo on 1/30/17.
//  Copyright © 2017 Apollo. All rights reserved.
//

import Foundation
import ObjectMapper

class PerformanceInfo: HRMSModel {
    var id: Int = 0
    var begda: String = "0000-00-00"
    var endda: String = "0000-00-00"
    var filter: String = ""
    var rows: Int = 0
    var skip: Int = 0
    var pernr: String = ""
    var nachn: String = ""
    var pefya: String = ""
    var pefty: String = ""
    var peflv: String = ""
    var pefsc: Int = 0
    var flow_ID: Int = 0
    
    required init?(map: Map) { super.init(map: map) }
    
    override func mapping(map: Map) {
        
        id <- map["id"]
        begda <- map["BEGDA"]
        endda <- map["ENDDA"]
        filter <- map["filter"]
        rows <- map["rows"]
        skip <- map["skip"]
        pernr <- map["PERNR"]
        nachn <- map["NACHN"]
        pefya <- map["PEFYA"]
        pefty <- map["PEFTY"]
        peflv <- map["PEFLV"]
        pefsc <- map["PEFSC"]
        flow_ID <- map["flow_ID"]
    }
}

class PerformanceInfoResponse: HRMSResponse {
    var data: [PerformanceInfo]?
    
    required init?(map: Map) { super.init(map: map) }
    
    override func mapping(map: Map) {
        super.mapping(map: map)

        data <- map["performanceList"]
    }
}
