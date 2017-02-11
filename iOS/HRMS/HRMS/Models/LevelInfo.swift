//
//  LevelInfo.swift
//  HRMS
//
//  Created by Apollo on 1/27/17.
//  Copyright © 2017 Apollo. All rights reserved.
//


import Foundation
import ObjectMapper

class LevelParams: HRMSModel {
    var par010: [ParamModel]?
    
    required init?(map: Map) { super.init(map: map) }
    
    override func mapping(map: Map) {
        super.mapping(map: map)
        
        par010 <- map["par010"]
    }
}

class LevelInfo: HRMSModel {
    var id: Int = 0
    var filter: String = ""
    var rows: Int = 0
    var skip: Int = 0
    var pernr: String = ""
    var ctdat: String = "0000-00-00"
    var ctnum: String = ""
    var ctunt: String = ""
    var hqflv: String = ""
    var qftyp: String = ""
    var qflvl: String = ""
    var flow_ID: Int = 0
    
    required init?(map: Map) { super.init(map: map) }
    
    override func mapping(map: Map) {
        
        id <- map["id"]
        filter <- map["filter"]
        rows <- map["rows"]
        skip <- map["skip"]
        pernr <- map["pernr"]
        ctdat <- map["ctdat"]
        ctnum <- map["ctnum"]
        ctunt <- map["ctunt"]
        hqflv <- map["hqflv"]
        qftyp <- map["qftyp"]
        qflvl <- map["qflvl"]
        flow_ID <- map["flow_ID"]
    }
}

class LevelInfoResponse: HRMSResponse {
    var paramList: LevelParams? //[String: [ParamModel]] = [:]
    var levels: [LevelInfo]?
    
    required init?(map: Map) { super.init(map: map) }
    
    override func mapping(map: Map) {
        super.mapping(map: map)
        
        paramList <- map["params"]
        levels <- map["titles"]
    }
}
