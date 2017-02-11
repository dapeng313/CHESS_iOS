//
//  SubAttendanceInfo.swift
//  HRMS
//
//  Created by Apollo on 2/1/17.
//  Copyright © 2017 Apollo. All rights reserved.
//

import Foundation
import ObjectMapper

class SubAttendanceInfo: HRMSModel {
    
    var id: Int = 0
    var pernr: String = ""
    var nachn: String = ""
    var filter: String = ""
    var rows: Int = 0
    var skip: Int = 0
    var begda: String = ""
    var endda: String = ""
    var cloda: String = ""
    var cloin: String = ""
    var cinad: String = ""
    var cloou: String = ""
    var couad: String = ""
    var clorm: String = ""
    var extim: String = ""
    
    required init?(map: Map) { super.init(map: map) }
    
    override func mapping(map: Map) {
        
        id <- map["id"]
        pernr <- map["PERNR"]
        nachn <- map["NACHN"]
        filter <- map["filter"]
        rows <- map["rows"]
        skip <- map["skip"]
        begda <- map["begda"]
        endda <- map["endda"]
        cloda <- map["cloda"]
        cloin <- map["cloin"]
        cinad <- map["cinad"]
        cloou <- map["cloou"]
        couad <- map["couad"]
        clorm <- map["clorm"]
        extim <- map["extim"]
    }
}

class SubAttendanceInfoResponse: HRMSResponse {
    var pt1001List: [SubAttendanceInfo]?
    var pt1002List: [SubAttendanceInfo]?
    var pt1003List: [SubAttendanceInfo]?
    var pt1004List: [SubAttendanceInfo]?
    
    required init?(map: Map) { super.init(map: map) }
    
    override func mapping(map: Map) {
        super.mapping(map: map)
        
        pt1001List <- map["pt1001List"]
        pt1002List <- map["pt1002List"]
        pt1003List <- map["pt1003List"]
        pt1004List <- map["pt1004List"]
    }
}
