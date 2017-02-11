//
//  BaseInfo.swift
//  HRMS
//
//  Created by Apollo on 1/26/17.
//  Copyright © 2017 Apollo. All rights reserved.
//

import Foundation
import ObjectMapper

class BaseParams: HRMSModel {
    var par004: [ParamModel]?
    var par005: [ParamModel]?
    var par006: [ParamModel]?
    var par037: [ParamModel]?
    var par038: [ParamModel]?
    var par039: [ParamModel]?
    var par040: [ParamModel]?


    required init?(map: Map) { super.init(map: map) }
    
    override func mapping(map: Map) {
        super.mapping(map: map)
        
        par004 <- map["par004"]
        par005 <- map["par005"]
        par006 <- map["par006"]
        par037 <- map["par037"]
        par038 <- map["par038"]
        par039 <- map["par039"]
        par040 <- map["par040"]
    }
}

class BaseInfoResponse: HRMSResponse {
    var nationalList: [ParamModel]?
    var countryList: [ParamModel]?
    var paramList: BaseParams? //[String: [ParamModel]] = [:]
    var pa1001: PA1001?
    var pa1002: PA1002?
    var coname: String?
    
    required init?(map: Map) { super.init(map: map) }
    
    override func mapping(map: Map) {
        super.mapping(map: map)
        
        nationalList <- map["nationalList"]
        countryList <- map["countryList"]
        paramList <- map["params"]
        pa1001 <- map["pa1001"]
        pa1002 <- map["pa1002"]
        coname <- map["coname"]
    }
}
