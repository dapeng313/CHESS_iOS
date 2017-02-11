//
//  WorkInfo.swift
//  HRMS
//
//  Created by Apollo on 1/27/17.
//  Copyright © 2017 Apollo. All rights reserved.
//


import Foundation
import ObjectMapper

class WorkParams: HRMSModel {
    var par025: [ParamModel]?
    
    required init?(map: Map) { super.init(map: map) }
    
    override func mapping(map: Map) {
        super.mapping(map: map)
        
        par025 <- map["par025"]
    }
}

class WorkInfo: HRMSModel {
    var id: Int = 0
    var begda: String = "0000-00-00"
    var filter: String = ""
    var rows: Int = 0
    var skip: Int = 0
    var pernr: String = ""
    var endda: String = "0000-00-00"
    var untur: String = ""
    var unnam: String = ""
    var unpos: String = ""
    var flow_ID: Int = 0
    
    required init?(map: Map) { super.init(map: map) }
    
    override func mapping(map: Map) {
        
        id <- map["id"]
        begda <- map["begda"]
        filter <- map["filter"]
        rows <- map["rows"]
        skip <- map["skip"]
        pernr <- map["pernr"]
        endda <- map["endda"]
        untur <- map["untur"]
        unnam <- map["unnam"]
        unpos <- map["unpos"]
        flow_ID <- map["flow_ID"]
    }
}

class WorkInfoResponse: HRMSResponse {
    var paramList: WorkParams? //[String: [ParamModel]] = [:]
    var works: [WorkInfo]?
    
    required init?(map: Map) { super.init(map: map) }
    
    override func mapping(map: Map) {
        super.mapping(map: map)
        
        paramList <- map["params"]
        works <- map["works"]
    }
}
