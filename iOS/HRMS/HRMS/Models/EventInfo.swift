//
//  EventInfo.swift
//  HRMS
//
//  Created by Apollo on 1/27/17.
//  Copyright © 2017 Apollo. All rights reserved.
//

import Foundation
import ObjectMapper

class EventParams: HRMSModel {
    var par002: [ParamModel]?
    var par003: [ParamModel]?
    var par037: [ParamModel]?
    var par041: [ParamModel]?
    var par042: [ParamModel]?
    var par043: [ParamModel]?
    var par044: [ParamModel]?
    var par045: [ParamModel]?
    var par046: [ParamModel]?
    var vpar: [ParamModel]?
    
    required init?(map: Map) { super.init(map: map) }
    
    override func mapping(map: Map) {
        super.mapping(map: map)
        
        par002 <- map["par002"]
        par003 <- map["par003"]
        par037 <- map["par037"]
        par041 <- map["par041"]
        par042 <- map["par042"]
        par043 <- map["par043"]
        par044 <- map["par044"]
        par045 <- map["par045"]
        par046 <- map["par046"]
        vpar <- map["vpar"]
    }
}

class EventInfo: HRMSModel {
    var id: Int = 0
    var begda: String = "0000-00-00"
    var filter: String = ""
    var rows: Int = 0
    var skip: Int = 0
    var pernr: String = ""
    var massn: String = ""
    var massg: String = ""
    var flowid: String = ""
    var estua: String = ""
    var read_ID: Int = 0
    
    required init?(map: Map) { super.init(map: map) }
    
    override func mapping(map: Map) {
        
        id <- map["id"]
        begda <- map["begda"]
        filter <- map["filter"]
        rows <- map["rows"]
        skip <- map["skip"]
        pernr <- map["pernr"]
        massn <- map["massn"]
        massg <- map["massg"]
        flowid <- map["flowid"]
        estua <- map["estua"]
        read_ID <- map["read_ID"]
    }
}

class EventInfoResponse: HRMSResponse {
    var paramList: EventParams? //[String: [ParamModel]] = [:]
    var events: [EventInfo]?
    
    required init?(map: Map) { super.init(map: map) }
    
    override func mapping(map: Map) {
        super.mapping(map: map)
        
        paramList <- map["params"]
        events <- map["events"]
    }
}
