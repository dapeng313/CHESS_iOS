//
//  TrainInfo.swift
//  HRMS
//
//  Created by Apollo on 1/27/17.
//  Copyright © 2017 Apollo. All rights reserved.
//


import Foundation
import ObjectMapper

class TrainParams: HRMSModel {
    var par052: [ParamModel]?
    
    required init?(map: Map) { super.init(map: map) }
    
    override func mapping(map: Map) {
        super.mapping(map: map)
        
        par052 <- map["par052"]
    }
}

class TrainInfo: HRMSModel {
    var id: Int = 0
    var begda: String = "0000-00-00"
    var filter: String = ""
    var rows: Int = 0
    var skip: Int = 0
    var pernr: String = ""
    var endda: String = "0000-00-00"
    var trype: String = ""
    var couna: String = ""
    var trrst: String = ""
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
        trype <- map["trype"]
        couna <- map["couna"]
        trrst <- map["trrst"]
        flow_ID <- map["flow_ID"]
    }
}

class TrainInfoResponse: HRMSResponse {
    var paramList: TrainParams? //[String: [ParamModel]] = [:]
    var trains: [TrainInfo]?
    
    required init?(map: Map) { super.init(map: map) }
    
    override func mapping(map: Map) {
        super.mapping(map: map)
        
        paramList <- map["params"]
        trains <- map["trains"]
    }
}
