//
//  SubCourseInfo.swift
//  HRMS
//
//  Created by Apollo on 2/1/17.
//  Copyright © 2017 Apollo. All rights reserved.
//

import Foundation
import ObjectMapper

class CourseStatusInfo: HRMSModel {

    var filter: String = ""
    var rows: Int = 0
    var skip: Int = 0
    var pernr: String = ""
    var begda: String = "0000-00-00"
    var endda: String = "0000-00-00"
    var trype: String = ""
    var trrst: String = ""
    var couna: String = ""
    var id: Int = 0
    
    required init?(map: Map) { super.init(map: map) }
    
    override func mapping(map: Map) {

        filter <- map["filter"]
        rows <- map["rows"]
        skip <- map["skip"]
        pernr <- map["pernr"]
        begda <- map["begda"]
        endda <- map["endda"]
        trype <- map["trype"]
        trrst <- map["trrst"]
        couna <- map["couna"]
        id <- map["id"]
    }
}

class CourseStatusInfoResponse: HRMSResponse {
    var data: [CourseStatusInfo]?
    
    required init?(map: Map) { super.init(map: map) }
    
    override func mapping(map: Map) {
        super.mapping(map: map)
        
        data <- map["rows"]
    }
}

class CourseInfo: HRMSModel {
    
    var filter: String = ""
    var rows: Int = 0
    var skip: Int = 0
    var pernr: String = ""
    var begda: String = "0000-00-00"
    var endda: String = "0000-00-00"
    var trype: String = ""
    var couad: String = ""
    var coudt: String = ""
    var couna: String = ""
    var couno: String = ""
    var coute: String = ""
    var coust: String = ""
    var id: Int = 0
    
    required init?(map: Map) { super.init(map: map) }
    
    override func mapping(map: Map) {
        
        filter <- map["filter"]
        rows <- map["rows"]
        skip <- map["skip"]
        pernr <- map["pernr"]
        begda <- map["BEGDA"]
        endda <- map["ENDDA"]
        trype <- map["TRYPE"]
        couad <- map["COUAD"]
        coudt <- map["COUDT"]
        couna <- map["COUNA"]
        couno <- map["COUNO"]
        coute <- map["COUTE"]
        coust <- map["COUST"]
        id <- map["id"]
    }
}

class CourseInfoResponse: HRMSResponse {
    var courseList: [CourseInfo]?
    
    required init?(map: Map) { super.init(map: map) }
    
    override func mapping(map: Map) {
        super.mapping(map: map)
        
        courseList <- map["courseList"]
    }
}
